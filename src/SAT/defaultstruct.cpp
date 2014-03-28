//
// MATLAB Compiler: 3.0
// Date: Wed Jul 14 15:58:49 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "test2" 
//
#include "defaultstruct.hpp"
#include "libmatlbm.hpp"
#include "libmmfile.hpp"
static mwArray _mxarray0_ = mclInitializeDouble(0.0);
static mwArray _mxarray1_ = mclInitializeDoubleVector(0, 0, (double *)NULL);

void InitializeModule_defaultstruct() {
}

void TerminateModule_defaultstruct() {
}

static mwArray Mdefaultstruct(int nargout_,
                              mwArray x,
                              mwArray d,
                              mwArray Empty2Default);

_mexLocalFunctionTable _local_function_table_defaultstruct
  = { 0, (mexFunctionTableEntry *)NULL };

//
// The function "defaultstruct" contains the normal interface for the
// "defaultstruct" M-function from file
// "c:\matlab6p5\work\asap\_sat\_sat\defaultstruct.m" (lines 1-26). This
// function processes any input arguments and passes them to the implementation
// version of the function, appearing above.
//
mwArray defaultstruct(mwArray x, mwArray d, mwArray Empty2Default) {
    int nargout = 1;
    mwArray y = mwArray::UNDEFINED;
    y = Mdefaultstruct(nargout, x, d, Empty2Default);
    return y;
}

//
// The function "mlxDefaultstruct" contains the feval interface for the
// "defaultstruct" M-function from file
// "c:\matlab6p5\work\asap\_sat\_sat\defaultstruct.m" (lines 1-26). The feval
// function calls the implementation version of defaultstruct through this
// function. This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
void mlxDefaultstruct(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[3];
        mwArray mplhs[1];
        int i;
        mclCppUndefineArrays(1, mplhs);
        if (nlhs > 1) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: defaultstruct Line: 2 Column"
                  ": 1 The function \"defaultstruct\" was called with"
                  " more than the declared number of outputs (1).")));
        }
        if (nrhs > 3) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: defaultstruct Line: 2 Column"
                  ": 1 The function \"defaultstruct\" was called with"
                  " more than the declared number of inputs (3).")));
        }
        for (i = 0; i < 3 && i < nrhs; ++i) {
            mprhs[i] = mwArray(prhs[i], 0);
        }
        for (; i < 3; ++i) {
            mprhs[i].MakeDIN();
        }
        mplhs[0] = Mdefaultstruct(nlhs, mprhs[0], mprhs[1], mprhs[2]);
        plhs[0] = mplhs[0].FreezeData();
    }
    MW_END_MLX();
}

//
// The function "Mdefaultstruct" is the implementation version of the
// "defaultstruct" M-function from file
// "c:\matlab6p5\work\asap\_sat\_sat\defaultstruct.m" (lines 1-26). It contains
// the actual compiled code for that M-function. It is a static function and
// must only be called from one of the interface functions, appearing below.
//
//
// 
// function y=DefaultStruct(x,d,Empty2Default)
//
static mwArray Mdefaultstruct(int nargout_,
                              mwArray x,
                              mwArray d,
                              mwArray Empty2Default) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_defaultstruct;
    int nargin_ = nargin(3, mwVarargin(x, d, Empty2Default));
    mwArray y = mwArray::UNDEFINED;
    mwArray xf = mwArray::UNDEFINED;
    mwArray f = mwArray::UNDEFINED;
    mwArray m = mwArray::UNDEFINED;
    mwArray n = mwArray::UNDEFINED;
    //
    // 
    // % y=DefaultStruct(x,d) returns a struct which is
    // % composed of all fields of the struct x and of the fields of 
    // % d which are not present in x. So the fields of d serve as defaults.
    // %
    // % y=DefaultStruct(x,d,1) uses also for empty x-fields the default 
    // % value from d. 
    // 
    // if (nargin<3)|isempty(Empty2Default),
    //
    mwArray a_ = nargin_ < 3;
    if (tobool(a_)
        || tobool(a_ | isempty(mwVa(Empty2Default, "Empty2Default")))) {
        //
        // Empty2Default=0;
        //
        Empty2Default = _mxarray0_;
    } else {
    }
    //
    // end
    // 
    // y=d;
    //
    y = mwVa(d, "d");
    //
    // 
    // n=fieldnames(x);
    //
    n = fieldnames(mwVa(x, "x"));
    //
    // 
    // for m=1:length(n(:)),
    //
    {
        int v_ = mclForIntStart(1);
        int e_ = mclLengthInt(mclArrayRef(mwVv(n, "n"), colon()));
        if (v_ > e_) {
            m = _mxarray1_;
        } else {
            //
            // f=n{m};
            // xf=getfield(x,f);
            // if ~(isempty(xf)&Empty2Default),
            // y=setfield(y,f,xf);
            // end
            // end
            //
            for (; ; ) {
                f = mwVv(n, "n").cell(v_);
                xf = getfield(mwVa(x, "x"), mwVarargin(mwVv(f, "f")));
                if (mclNotBool(
                      isempty(mwVv(xf, "xf"))
                      & mwVa(Empty2Default, "Empty2Default"))) {
                    y
                      = setfield(
                          mwVv(y, "y"),
                          mwVarargin(mwVv(f, "f"), mwVv(xf, "xf")));
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            m = v_;
        }
    }
    mwValidateOutput(y, 1, nargout_, "y", "defaultstruct");
    return y;
}
