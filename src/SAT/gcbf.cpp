//
// MATLAB Compiler: 3.0
// Date: Wed Jul 14 15:58:49 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "test2" 
//
#include "gcbf.hpp"
#include "gcbo.hpp"
#include "libmatlbm.hpp"

void InitializeModule_gcbf() {
}

void TerminateModule_gcbf() {
}

static mwArray Mgcbf(int nargout_);

_mexLocalFunctionTable _local_function_table_gcbf
  = { 0, (mexFunctionTableEntry *)NULL };

//
// The function "gcbf" contains the normal interface for the "gcbf" M-function
// from file "c:\matlab6p5\toolbox\matlab\graphics\gcbf.m" (lines 1-19). This
// function processes any input arguments and passes them to the implementation
// version of the function, appearing above.
//
mwArray gcbf() {
    int nargout = 1;
    mwArray fig = mwArray::UNDEFINED;
    fig = Mgcbf(nargout);
    return fig;
}

//
// The function "mlxGcbf" contains the feval interface for the "gcbf"
// M-function from file "c:\matlab6p5\toolbox\matlab\graphics\gcbf.m" (lines
// 1-19). The feval function calls the implementation version of gcbf through
// this function. This function processes any input arguments and passes them
// to the implementation version of the function, appearing above.
//
void mlxGcbf(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mplhs[1];
        mclCppUndefineArrays(1, mplhs);
        if (nlhs > 1) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: gcbf Line: 1 Column: 1"
                  " The function \"gcbf\" was called with more "
                  "than the declared number of outputs (1).")));
        }
        if (nrhs > 0) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: gcbf Line: 1 Column: 1"
                  " The function \"gcbf\" was called with more "
                  "than the declared number of inputs (0).")));
        }
        mplhs[0] = Mgcbf(nlhs);
        plhs[0] = mplhs[0].FreezeData();
    }
    MW_END_MLX();
}

//
// The function "Mgcbf" is the implementation version of the "gcbf" M-function
// from file "c:\matlab6p5\toolbox\matlab\graphics\gcbf.m" (lines 1-19). It
// contains the actual compiled code for that M-function. It is a static
// function and must only be called from one of the interface functions,
// appearing below.
//
//
// function fig = gcbf
//
static mwArray Mgcbf(int nargout_) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_gcbf;
    mwArray fig = mwArray::UNDEFINED;
    mwArray obj = mwArray::UNDEFINED;
    //
    // %GCBF Get handle to current callback figure.
    // %   FIG = GCBF returns the handle of the figure that contains the object
    // %   whose callback is currently executing.  If the current callback object
    // %   is the figure, the figure is returned.
    // %
    // %   When no callbacks are executing, GCBF returns [].  If the current figure
    // %   gets deleted during callback execution, GCBF returns [].
    // %
    // %   The return value of GCBF is identical to the FIGURE output argument of
    // %   GCBO.
    // %
    // %   See also GCBO, GCO, GCF, GCA.
    // 
    // %   Copyright 1984-2002 The MathWorks, Inc. 
    // %   $Revision: 1.10 $  $Date: 2002/04/08 22:41:29 $
    // 
    // [obj, fig] = gcbo;
    //
    obj = Ngcbo(2, &fig);
    mwValidateOutput(fig, 1, nargout_, "fig", "gcbf");
    return fig;
}
