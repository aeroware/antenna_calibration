//
// MATLAB Compiler: 3.0
// Date: Wed Jul 14 15:58:49 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "test2" 
//
#ifndef __strread_hpp
#define __strread_hpp 1

#include "libmatlb.hpp"

extern void InitializeModule_strread();
extern void TerminateModule_strread();
extern _mexLocalFunctionTable _local_function_table_strread;

extern mwArray Nstrread(int nargout,
                        mwVarargout varargout,
                        mwVarargin varargin = mwVarargin::DIN);
extern mwArray strread(mwVarargout varargout,
                       mwVarargin varargin = mwVarargin::DIN);
extern void Vstrread(mwVarargin varargin = mwVarargin::DIN);
#ifdef __cplusplus
extern "C"
#endif
void mlxStrread(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
