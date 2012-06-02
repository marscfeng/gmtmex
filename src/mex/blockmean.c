/*
 *	$Id$
 *
 *	Copyright (c) 1991-2012 by P. Wessel, W. H. F. Smith, R. Scharroo, and J. Luis
 *      See LICENSE.TXT file for copying and redistribution conditions.
 *
 *      This program is free software; you can redistribute it and/or modify
 *      it under the terms of the GNU Lesser General Public License as published by
 *      the Free Software Foundation; version 3 or any later version.
 *
 *      This program is distributed in the hope that it will be useful,
 *      but WITHOUT ANY WARRANTY; without even the implied warranty of
 *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *      GNU Lesser General Public License for more details.
 *
 *      Contact info: www.soest.hawaii.edu/pwessel
 *--------------------------------------------------------------------*/
/* Program:	MATLAB/OCTAVE interface to blockmean
 */
 
#include "gmt_mex.h"

/* Matlab Gateway routine for blockmean */

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	int status;
	struct	GMTAPI_CTRL *API = NULL;		/* GMT API control structure */
	struct	GMT_VECTOR *Vi = NULL;
	struct	GMT_VECTOR *Vo = NULL;
	float	*Z = NULL;
	char	*input = NULL, *output = NULL, *options = NULL, *cmd = NULL; 
	int	n_cols;

	/* Make sure in/out arguments match expectation, or give usage message */
	if (!(nrhs == 2 || nrhs == 4 || nrhs == 5) || !(nlhs == 0 || nlhs == 3 || nlhs == 4 || nlhs == 7)) {	/* Not what we expected, or nothing */
		GMT5MEX_banner;
		mexPrintf ("usage: [x y z] = blockmean ('filename', 'options');\n");
		mexPrintf ("	[x y z[,s,l,h][,w]] = blockmean (xi, yi, zi[, wi], 'options');\n");
		mexPrintf ("	[x y z[,s,l,h][,w]] = blockmean ('filename', 'options');\n");
		return;
	}
	if (!mxIsChar(prhs[nrhs-1])) mexErrMsgTxt ("Last input must contain the options string\n");

	/* Initializing new GMT session */
	if ((API = GMT_Create_Session ("GMT/MEX-API", k_mode_gmt)) == NULL) mexErrMsgTxt ("Failure to create GMT Session\n");

	/* Make sure options are given, and get them */
	options = GMTMEX_options_init (API, prhs, nrhs);

	/* Set up input file (actual or via Matlab vectors) */
	n_cols = (nrhs == 2) ? 0 : nrhs - 1;
	input = GMTMEX_src_vector_init (API, prhs, n_cols, 0, &Vi);

	/* Register output vectors Vo to be the destination, allocated and written to by the module */
	output = GMTMEX_dest_vector_init (API, (int)nlhs, &Vo, nlhs, options);

	/* Build module command from input, ouptput, and option strings */
	cmd = GMTMEX_build_cmd (API, input, options, output, GMT_IS_DATASET);
	mexPrintf ("cmd = (%s)\n", cmd);
	/* Run blockmean module, and give usage message if errors arise during parsing */
	if ((status = GMT_blockmean (API, 0, cmd))) mexErrMsgTxt ("Run-time error\n");
	
	/* Pass output arguments to Matlab column vectors. */
	if (nlhs) GMTMEX_prep_mextbl (API, plhs, nlhs, Vo);

	/* Destroy the columns returned from the module  */
	GMT_free_vector (API->GMT, &Vo, true);	/* true since vectors are being duplicated for Matlab */
	
	/* Free temporary local variables  */
	GMTMEX_free (input, output, options, cmd);
	GMT_free_vector (API->GMT, &Vi, false);	/* false since vectors came from Matlab */
	
	/* Destroy GMT API session */
	if (GMT_Destroy_Session (&API)) mexErrMsgTxt ("Failure to destroy GMT Session\n");

	return;
}
