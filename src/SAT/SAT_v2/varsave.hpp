//
// MATLAB Compiler: 3.0
// Date: Wed Jul 14 15:58:49 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "test2" 
//
#ifndef __varsave_hpp
#define __varsave_hpp 1

#include "libmatlb.hpp"

extern void InitializeModule_varsave();
extern void TerminateModule_varsave();
extern _mexLocalFunctionTable _local_function_table_varsave;

extern void varsave(mwArray f = mwArray::DIN,
                    mwArray v = mwArray::DIN,
                    mwArray n = mwArray::DIN,
                    mwArray VarName = mwArray::DIN,
                    mwArray OneFile = mwArray::DIN);
#ifdef __cplusplus
extern "C"
#endif
void mlxVarsave(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
