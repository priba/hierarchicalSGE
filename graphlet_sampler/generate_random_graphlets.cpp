/* Date: Sun, 21 Jun 92 19:33:02 -0400
* From: adutta@cvc.uab.es (Anjan Dutta)
* Sun, 21 Jun 92 19:32:59 -0400
* -----------------------------------generate_random_graphlet.cpp --------------------------------------
*
* The mex function implementation is done by Anjan Dutta 
*/
#include <mex.h>
#include "matrix.h"
#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <algorithm>    // std::sort
#include <set>
#include <list>
#include <vector>
#include<iostream>

#ifdef CPU_TIME
#include <sys/times.h>
#include <sys/param.h>
#endif

// Define the input and output argument of the mex function
// Input Arguments
#define	LIST_EDGES_IN prhs[0]
#define NUM_GRAPHLETS_IN prhs[1]
#define MAX_SIZE_IN prhs[2]
// Output Arguments
#define	LIST_GRAPHLETS_OUT plhs[0]
using namespace std;
/*
 * Types.
 */
typedef struct edge{
	unsigned int start, end;
}EDGE;
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	unsigned int i;
	if(nrhs<3) 
	{
		mexErrMsgTxt("\nError: Input arguments must be three.\n");
		return;
	}
	if(nlhs>1)
	{
		mexErrMsgTxt("\nError: Too many output arguments.\n");
		return;
	}
	if(mxGetM(LIST_EDGES_IN)<1)
	{
        char buffer [150];
        sprintf (buffer, "\nError: Check the dimension M of list of edges.\nRecieved %lu instead of more than 1.\n", mxGetM(LIST_EDGES_IN));
		mexErrMsgTxt(buffer);
		return;
	}
	if(mxGetN(LIST_EDGES_IN)!=2)
	{
        char buffer [150];
        sprintf (buffer, "\nError: Check the dimension N of list of edges.\nRecieved %lu instead of 2.\n", mxGetN(LIST_EDGES_IN));
		mexErrMsgTxt(buffer);
		return;
	}

	mxArray *mxlist_edges_input = (mxArray *)LIST_EDGES_IN;
	mxArray *mxnum_graphlets_input = (mxArray *)NUM_GRAPHLETS_IN;
	mxArray *mxmax_size_input = (mxArray *)MAX_SIZE_IN;	

	unsigned int *list_edges_input = (unsigned int *)mxGetData(mxlist_edges_input);
	unsigned int *num_graphlets_input = (unsigned int *)mxGetData(mxnum_graphlets_input);
	unsigned int *max_size_input = (unsigned int *)mxGetData(mxmax_size_input);

	mxArray *cell_matrix = mxCreateCellMatrix(*num_graphlets_input**max_size_input,1);

	int num_edges = mxGetM(mxlist_edges_input);

	// First copy the edges into a list and the nodes into a set

	std::list<EDGE> edges;
	std::set<unsigned int> nodes;
	for(int i = 0;i<num_edges;i++)
	{
		EDGE edge;
		edge.start = list_edges_input[i];
		edge.end = list_edges_input[i+num_edges];
		edges.push_back(edge);

		nodes.insert(list_edges_input[i]);
		nodes.insert(list_edges_input[i+num_edges]);
	}	
	
	// Now create a node to edges indices, this is an array of sets. Each set is dedicated
	// for a node and it contains the indices of the edges

	std::set<unsigned int> *n2eidx = new set<unsigned int>[*std::max_element(nodes.begin(), nodes.end())];

	std::list<EDGE>::iterator it_edges;
	it_edges = edges.begin();
	unsigned int count_edges = 0;

	while(it_edges!=edges.end())
	{
		n2eidx[it_edges->start-1].insert(count_edges);
		n2eidx[it_edges->end-1].insert(count_edges++);	

		it_edges++;
	}

	short flag;

	std::list<EDGE> visited_edges;
	std::set<unsigned int> visited_nodes;
	std::set<unsigned int> poss_visited_edge_indices;
	std::set<unsigned int> indices_visited_edges;
	
	std::set<unsigned int>::iterator it_nodes;
	std::set<unsigned int>::iterator it_edge_indices;
	
	// Initialize the random seed
	srand(0);

	for(int iglet = 0; iglet < *num_graphlets_input**max_size_input; )
	{	
		visited_edges.clear();		
		visited_nodes.clear();
		
		// First Randomly choose a starting vertex

		unsigned int n;
		it_nodes = nodes.begin();
		std::advance(it_nodes,rand()%nodes.size());
		visited_nodes.insert(*it_nodes);
		flag = 0;

		// Clear the set of indices of visited edges

		indices_visited_edges.clear();
		
		for(int isize = 0; isize < *max_size_input; isize++)
		{
			
			while(1)
			{

				// Randomly select a node from the visited nodes set, say, x is that node

				it_nodes = visited_nodes.begin();
				std::advance(it_nodes,rand()%visited_nodes.size());
				unsigned int x = *it_nodes;

				// Check if all the edges connected to the node x is already visited or not
				// poss_visited_edge_indices = n2eidx[x-1] \ indices_visited_edges

				poss_visited_edge_indices.clear();
    			set_difference(n2eidx[x-1].begin(),n2eidx[x-1].end(),indices_visited_edges.begin(),indices_visited_edges.end(),std::inserter(poss_visited_edge_indices,poss_visited_edge_indices.begin()));

				// If visited, we eliminate the node x from the set of visited nodes 
				// otherwise we select a random edge (index) from there

				if(!poss_visited_edge_indices.size())
					visited_nodes.erase(it_nodes);
				else	
				{
					it_edge_indices = poss_visited_edge_indices.begin();
					std::advance(it_edge_indices,rand()%poss_visited_edge_indices.size());
					n = *it_edge_indices;					
					break;
				}

				// If the visited nodes set becomes empty somehow, we break the while(1) loop

				if(!visited_nodes.size())
				{
					flag = 1;
					break;
				}
								
			}

			// If the visited nodes set becomes empty, we break the for loop too

			if(flag)
				break;

			// Otherwise, put this edge to the visited edges set and also update the indices set

			indices_visited_edges.insert(n);
			it_edges = edges.begin();
			std::advance(it_edges,n);
			visited_edges.push_back(*it_edges);
			
			// Put the nodes of the visited edges to the visited nodes and all the edges of the
			// visited edges set to a graphlet

			mxArray *graphlet_ptr = mxCreateNumericMatrix(1,2*visited_edges.size(),mxUINT32_CLASS,mxREAL);

			unsigned int *graphlet = (unsigned int*)mxGetPr(graphlet_ptr);

			for(it_edges = visited_edges.begin();it_edges != visited_edges.end(); it_edges++)
			{
				visited_nodes.insert(it_edges->start);
				visited_nodes.insert(it_edges->end);
				
				*graphlet++ = it_edges->start;
				*graphlet++ = it_edges->end;				
			}

			// Set the graphlet to a cell containing graphlets

			mxSetCell(cell_matrix,iglet++,graphlet_ptr);

			// Check if the number of graphlets is greater than *num_graphlets_input**max_size_input
			// If yes break the procedure

			if(iglet==*num_graphlets_input**max_size_input)
				break;

		}

	}
	
	LIST_GRAPHLETS_OUT = cell_matrix;

	delete[] n2eidx;

	nodes.clear();
	edges.clear();
	visited_edges.clear();
	visited_nodes.clear();
	poss_visited_edge_indices.clear();
	indices_visited_edges.clear();	
}
