//
// MATLAB Compiler: 3.0
// Date: Wed Jul 14 15:58:49 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "test2" 
//
#ifndef __mkdir_hpp
#define __mkdir_hpp 1

#include "libmatlb.hpp"

extern void InitializeModule_mkdir();
extern void TerminateModule_mkdir();
extern _mexLocalFunctionTable _local_function_table_mkdir;

extern mwArray Nmkdir(int nargout,
                      mwVarargout varargout,
                      mwVarargin varargin = mwVarargin::DIN);
extern mwArray mkdir(mwVarargout varargout,
                     mwVarargin varargin = mwVarargin::DIN);
extern void Vmkdir(mwVarargin varargin = mwVarargin::DIN);
#ifdef __cplusplus
extern "C"
#endif
void mlxMkdir(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
