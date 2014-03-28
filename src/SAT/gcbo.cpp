//
// MATLAB Compiler: 3.0
// Date: Wed Jul 14 15:58:49 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "test2" 
//
#include "gcbo.hpp"
#include "libsgl.hpp"
#include "libmatlbm.hpp"
static mwArray _mxarray0_ = mclInitializeDouble(0.0);

static mxChar _array2_[14] = { 'C', 'a', 'l', 'l', 'b', 'a', 'c',
                               'k', 'O', 'b', 'j', 'e', 'c', 't' };
static mwArray _mxarray1_ = mclInitializeString(14, _array2_);
static mwArray _mxarray3_ = mclInitializeDoubleVector(0, 0, (double *)NULL);

static mxChar _array5_[6] = { 'p', 'a', 'r', 'e', 'n', 't' };
static mwArray _mxarray4_ = mclInitializeString(6, _array5_);

void InitializeModule_gcbo() {
}

void TerminateModule_gcbo() {
}

static mwArray Mgcbo(mwArray * fig, int nargout_);

_mexLocalFunctionTable _local_function_table_gcbo
  = { 0, (mexFunctionTableEntry *)NULL };

//
// The function "Ngcbo" contains the nargout interface for the "gcbo"
// M-function from file "c:\matlab6p5\toolbox\matlab\graphics\gcbo.m" (lines
// 1-61). This interface is only produced if the M-function uses the special
// variable "nargout". The nargout interface allows the number of requested
// outputs to be specified via the nargout argument, as opposed to the normal
// interface which dynamically calculates the number of outputs based on the
// number of non-NULL inputs it receives. This function processes any input
// arguments and passes them to the implementation version of the function,
// appearing above.
//
mwArray Ngcbo(int nargout, mwArray * fig) {
    mwArray object = mwArray::UNDEFINED;
    mwArray fig__ = mwArray::UNDEFINED;
    object = Mgcbo(&fig__, nargout);
    if (fig != NULL) {
        *fig = fig__;
    }
    return object;
}

//
// The function "gcbo" contains the normal interface for the "gcbo" M-function
// from file "c:\matlab6p5\toolbox\matlab\graphics\gcbo.m" (lines 1-61). This
// function processes any input arguments and passes them to the implementation
// version of the function, appearing above.
//
mwArray gcbo(mwArray * fig) {
    int nargout = 1;
    mwArray object = mwArray::UNDEFINED;
    mwArray fig__ = mwArray::UNDEFINED;
    if (fig != NULL) {
        ++nargout;
    }
    object = Mgcbo(&fig__, nargout);
    if (fig != NULL) {
        *fig = fig__;
    }
    return object;
}

//
// The function "Vgcbo" contains the void interface for the "gcbo" M-function
// from file "c:\matlab6p5\toolbox\matlab\graphics\gcbo.m" (lines 1-61). The
// void interface is only produced if the M-function uses the special variable
// "nargout", and has at least one output. The void interface function
// specifies zero output arguments to the implementation version of the
// function, and in the event that the implementation version still returns an
// output (which, in MATLAB, would be assigned to the "ans" variable), it
// deallocates the output. This function processes any input arguments and
// passes them to the implementation version of the function, appearing above.
//
void Vgcbo() {
    mwArray object = mwArray::UNDEFINED;
    mwArray fig = mwArray::UNDEFINED;
    object = Mgcbo(&fig, 0);
}

//
// The function "mlxGcbo" contains the feval interface for the "gcbo"
// M-function from file "c:\matlab6p5\toolbox\matlab\graphics\gcbo.m" (lines
// 1-61). The feval function calls the implementation version of gcbo through
// this function. This function processes any input arguments and passes them
// to the implementation version of the function, appearing above.
//
void mlxGcbo(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mplhs[2];
        int i;
        mclCppUndefineArrays(2, mplhs);
        if (nlhs > 2) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: gcbo Line: 1 Column: 1"
                  " The function \"gcbo\" was called with more "
                  "than the declared number of outputs (2).")));
        }
        if (nrhs > 0) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: gcbo Line: 1 Column: 1"
                  " The function \"gcbo\" was called with more "
                  "than the declared number of inputs (0).")));
        }
        mplhs[0] = Mgcbo(&mplhs[1], nlhs);
        plhs[0] = mplhs[0].FreezeData();
        for (i = 1; i < 2 && i < nlhs; ++i) {
            plhs[i] = mplhs[i].FreezeData();
        }
    }
    MW_END_MLX();
}

//
// The function "Mgcbo" is the implementation version of the "gcbo" M-function
// from file "c:\matlab6p5\toolbox\matlab\graphics\gcbo.m" (lines 1-61). It
// contains the actual compiled code for that M-function. It is a static
// function and must only be called from one of the interface functions,
// appearing below.
//
//
// function [object, fig] = gcbo
//
static mwArray Mgcbo(mwArray * fig, int nargout_) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_gcbo;
    mwArray object = mwArray::UNDEFINED;
    //
    // %GCBO Get handle to current callback object.
    // %   OBJECT = GCBO returns the handle of the object whose callback is
    // %   currently executing.  This handle is obtained from the root property
    // %   'CallbackObject'.
    // %   
    // %   [OBJECT, FIGURE] = GCBO returns the handle of the object whose callback
    // %   is currently executing, and the figure containing that object.
    // %
    // %   During a callback, GCBO can be used to obtain the handle of the object
    // %   whose callback is executing, and the figure which contains that object.
    // %   If one callback is interrupted by another, the root CallbackObject is
    // %   updated to contain the handle of the object whose callback is
    // %   interrupting.  When the execution of the interrupting callback has
    // %   completed, and the execution of the original callback resumes, the root
    // %   CallbackObject is restored to contain the handle of the original object.
    // %
    // %   The root CallbackObject property is read-only, so its value is
    // %   guaranteed to be valid at any time during a callback.  The root
    // %   CurrentFigure property, and the figure CurrentAxes and CurrentObject
    // %   properties (returned by GCF, GCA, and GCO respectively) are
    // %   user-settable, so they may change during the execution of a callback,
    // %   especially if that callback is interrupted by another callback.  As a
    // %   result, those functions should not be considered interchangeable with
    // %   GCBO, because they are not reliable indicators of which object's
    // %   callback is executing.
    // %
    // %   When no callbacks are executing, GCBO returns [].  If the current object
    // %   gets deleted during callback execution, GCBO returns [].
    // %
    // %   See also GCO, GCF, GCA, GCBF.
    // 
    // %   Copyright 1984-2002 The MathWorks, Inc. 
    // %   $Revision: 1.17 $  $Date: 2002/04/08 22:41:29 $
    // 
    // object = get(0, 'CallbackObject');
    //
    object = Nget(1, mwVarargin(_mxarray0_, _mxarray1_));
    //
    // 
    // % If object is not a handle, it was likely deleted, return empty
    // % to prevent subsequent GETs from failing.
    // if ~ishandle(object)
    //
    if (mclNotBool(ishandle(mwVv(object, "object")))) {
        //
        // object = [];
        //
        object = _mxarray3_;
    //
    // end
    //
    }
    //
    // 
    // % return the figure containing the object, if requested:
    // if nargout == 2,
    //
    if (nargout_ == 2) {
        //
        // if isempty(object),
        //
        if (tobool(isempty(mwVv(object, "object")))) {
            //
            // fig = [];
            //
            *fig = _mxarray3_;
        //
        // elseif isequal(object,0),
        //
        } else if (tobool(
                     isequal(mwVv(object, "object"), mwVarargin(_mxarray0_)))) {
            //
            // fig = [];
            //
            *fig = _mxarray3_;
        //
        // else,
        //
        } else {
            //
            // fig = object;
            //
            *fig = mwVv(object, "object");
            //
            // try
            //
            try {
                //
                // while ~isempty(fig) & ~isequal(get(fig,'parent'),0),
                //
                for (;;) {
                    mwArray a_ = ~ isempty(mwVv(*fig, "fig"));
                    if (tobool(a_)
                        && tobool(
                             a_
                             & ~ isequal(
                                   Nget(
                                     1,
                                     mwVarargin(
                                       mwVv(*fig, "fig"), _mxarray4_)),
                                   mwVarargin(_mxarray0_)))) {
                    } else {
                        break;
                    }
                    //
                    // fig = get(fig,'parent');
                    //
                    *fig = Nget(1, mwVarargin(mwVv(*fig, "fig"), _mxarray4_));
                //
                // end
                //
                }
            //
            // catch
            //
            } catch(mwException e_) {
                //
                // fig = [];
                //
                *fig = _mxarray3_;
            //
            // end
            //
            }
        //
        // end
        //
        }
    //
    // end
    //
    }
    mwValidateOutput(object, 1, nargout_, "object", "gcbo");
    mwValidateOutput(*fig, 2, nargout_, "fig", "gcbo");
    return object;
}
