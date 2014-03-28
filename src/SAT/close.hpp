//
// MATLAB Compiler: 3.0
// Date: Wed Jul 14 15:58:49 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "test2" 
//
#ifndef __close_hpp
#define __close_hpp 1

#include "libmatlb.hpp"

extern void InitializeModule_close();
extern void TerminateModule_close();
extern _mexLocalFunctionTable _local_function_table_close;

extern mwArray Nclose(int nargout, mwVarargin varargin = mwVarargin::DIN);
extern mwArray close(mwVarargin varargin = mwVarargin::DIN);
extern void Vclose(mwVarargin varargin = mwVarargin::DIN);
#ifdef __cplusplus
extern "C"
#endif
void mlxClose(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
