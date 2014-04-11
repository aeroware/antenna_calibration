//
// MATLAB Compiler: 3.0
// Date: Wed Jul 14 15:58:49 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "test2" 
//
#include "close.hpp"
#include "libsgl.hpp"
#include "gcbf.hpp"
#include "libmatlbm.hpp"
#include "libmmfile.hpp"
static mwArray _persistent_close_request_close__in_request_close;
static mwArray _mxarray0_ = mclInitializeDoubleVector(0, 0, (double *)NULL);
static mwArray _mxarray1_ = mclInitializeDouble(0.0);
static mwArray _mxarray2_ = mclInitializeDouble(1.0);

static mxChar _array4_[8] = { 'C', 'h', 'i', 'l', 'd', 'r', 'e', 'n' };
static mwArray _mxarray3_ = mclInitializeString(8, _array4_);

static mxChar _array6_[5] = { 'f', 'o', 'r', 'c', 'e' };
static mwArray _mxarray5_ = mclInitializeString(5, _array6_);

static mxChar _array8_[3] = { 'a', 'l', 'l' };
static mwArray _mxarray7_ = mclInitializeString(3, _array8_);

static mxChar _array10_[6] = { 'h', 'i', 'd', 'd', 'e', 'n' };
static mwArray _mxarray9_ = mclInitializeString(6, _array10_);

static mxChar _array12_[3] = { 'g', 'c', 'f' };
static mwArray _mxarray11_ = mclInitializeString(3, _array12_);

static mxChar _array14_[4] = { 'g', 'c', 'b', 'f' };
static mwArray _mxarray13_ = mclInitializeString(4, _array14_);

static mxChar _array16_[8] = { 'c', 'h', 'i', 'l', 'd', 'r', 'e', 'n' };
static mwArray _mxarray15_ = mclInitializeString(8, _array16_);

static mxChar _array18_[4] = { 'f', 'l', 'a', 't' };
static mwArray _mxarray17_ = mclInitializeString(4, _array18_);

static mxChar _array20_[4] = { 'n', 'a', 'm', 'e' };
static mwArray _mxarray19_ = mclInitializeString(4, _array20_);

static mxChar _array22_[32] = { 'S', 'p', 'e', 'c', 'i', 'f', 'i', 'e',
                                'd', ' ', 'w', 'i', 'n', 'd', 'o', 'w',
                                ' ', 'd', 'o', 'e', 's', ' ', 'n', 'o',
                                't', ' ', 'e', 'x', 'i', 's', 't', '.' };
static mwArray _mxarray21_ = mclInitializeString(32, _array22_);

static mxChar _array24_[17] = { 's', 'h', 'o', 'w', 'h', 'i', 'd', 'd', 'e',
                                'n', 'h', 'a', 'n', 'd', 'l', 'e', 's' };
static mwArray _mxarray23_ = mclInitializeString(17, _array24_);

static mxChar _array26_[2] = { 'o', 'n' };
static mwArray _mxarray25_ = mclInitializeString(2, _array26_);

static mxChar _array28_[4] = { 't', 'y', 'p', 'e' };
static mwArray _mxarray27_ = mclInitializeString(4, _array28_);

static mxChar _array30_[6] = { 'f', 'i', 'g', 'u', 'r', 'e' };
static mwArray _mxarray29_ = mclInitializeString(6, _array30_);

static mxChar _array32_[3] = { 'T', 'a', 'g' };
static mwArray _mxarray31_ = mclInitializeString(3, _array32_);

static mxChar _array34_[7] = { 'S', 'F', 'C', 'H', 'A', 'R', 'T' };
static mwArray _mxarray33_ = mclInitializeString(7, _array34_);

static mxChar _array36_[15] = { 'D', 'E', 'F', 'A', 'U', 'L', 'T', '_',
                                'S', 'F', 'C', 'H', 'A', 'R', 'T' };
static mwArray _mxarray35_ = mclInitializeString(15, _array36_);

static mxChar _array38_[7] = { 'S', 'F', 'E', 'X', 'P', 'L', 'R' };
static mwArray _mxarray37_ = mclInitializeString(7, _array38_);

static mxChar _array40_[11] = { 'S', 'F', '_', 'D', 'E', 'B',
                                'U', 'G', 'G', 'E', 'R' };
static mwArray _mxarray39_ = mclInitializeString(11, _array40_);

static mxChar _array42_[12] = { 'S', 'F', '_', 'S', 'A', 'F',
                                'E', 'H', 'O', 'U', 'S', 'E' };
static mwArray _mxarray41_ = mclInitializeString(12, _array42_);

static mxChar _array44_[6] = { 'S', 'F', '_', 'S', 'N', 'R' };
static mwArray _mxarray43_ = mclInitializeString(6, _array44_);

static mxChar _array46_[22] = { 'I', 'n', 'v', 'a', 'l', 'i', 'd', ' ',
                                'f', 'i', 'g', 'u', 'r', 'e', ' ', 'h',
                                'a', 'n', 'd', 'l', 'e', '.' };
static mwArray _mxarray45_ = mclInitializeString(22, _array46_);

static mxChar _array48_[13] = { 'C', 'u', 'r', 'r', 'e', 'n', 't',
                                'F', 'i', 'g', 'u', 'r', 'e' };
static mwArray _mxarray47_ = mclInitializeString(13, _array48_);

static mxChar _array50_[15] = { 'C', 'l', 'o', 's', 'e', 'R', 'e', 'q',
                                'u', 'e', 's', 't', 'F', 'c', 'n' };
static mwArray _mxarray49_ = mclInitializeString(15, _array50_);

static mxChar _array52_[72] = { 'A', ' ', 'c', 'a', 'l', 'l', 'b', 'a', 'c',
                                'k', ' ', 'r', 'e', 'c', 'u', 'r', 's', 'i',
                                'v', 'e', 'l', 'y', ' ', 'c', 'a', 'l', 'l',
                                's', ' ', 'C', 'L', 'O', 'S', 'E', '.', ' ',
                                ' ', 'U', 's', 'e', ' ', 'D', 'E', 'L', 'E',
                                'T', 'E', ' ', 't', 'o', ' ', 'p', 'r', 'e',
                                'v', 'e', 'n', 't', ' ', 't', 'h', 'i', 's',
                                ' ', 'm', 'e', 's', 's', 'a', 'g', 'e', '.' };
static mwArray _mxarray51_ = mclInitializeString(72, _array52_);
static mwArray _mxarray53_ = mclInitializeDouble(2.0);

static mxChar _array55_[15] = { 'f', 'u', 'n', 'c', 't', 'i', 'o', 'n',
                                '_', 'h', 'a', 'n', 'd', 'l', 'e' };
static mwArray _mxarray54_ = mclInitializeString(15, _array55_);

static mxChar _array57_[51] = { 'E', 'r', 'r', 'o', 'r', ' ', 'w', 'h', 'i',
                                'l', 'e', ' ', 'e', 'v', 'a', 'l', 'u', 'a',
                                't', 'i', 'n', 'g', ' ', 'f', 'i', 'g', 'u',
                                'r', 'e', ' ', 'C', 'l', 'o', 's', 'e', 'R',
                                'e', 'q', 'u', 'e', 's', 't', 'F', 'c', 'n',
                                0x005c, 'n', 0x005c, 'n', '%', 's' };
static mwArray _mxarray56_ = mclInitializeString(51, _array57_);

void InitializeModule_close() {
}

void TerminateModule_close() {
}

static mwArray close_request_close(mwArray h = mwArray::DIN);
#ifdef __cplusplus
extern "C"
#endif
void mlxClose_request_close(int nlhs,
                            mxArray * plhs[],
                            int nrhs,
                            mxArray * prhs[]);
static mwArray close_checkfigs(mwArray h = mwArray::DIN);
#ifdef __cplusplus
extern "C"
#endif
void mlxClose_checkfigs(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);
static mwArray Mclose(int nargout_, mwArray varargin);
static mwArray Mclose_request_close(int nargout_, mwArray h);
static mwArray Mclose_checkfigs(int nargout_, mwArray h);

static mexFunctionTableEntry local_function_table_[2]
  = { { "request_close", mlxClose_request_close, 1, 1, NULL },
      { "checkfigs", mlxClose_checkfigs, 1, 1, NULL } };

_mexLocalFunctionTable _local_function_table_close
  = { 2, local_function_table_ };

//
// The function "Nclose" contains the nargout interface for the "close"
// M-function from file "c:\matlab6p5\toolbox\matlab\graphics\close.m" (lines
// 1-112). This interface is only produced if the M-function uses the special
// variable "nargout". The nargout interface allows the number of requested
// outputs to be specified via the nargout argument, as opposed to the normal
// interface which dynamically calculates the number of outputs based on the
// number of non-NULL inputs it receives. This function processes any input
// arguments and passes them to the implementation version of the function,
// appearing above.
//
mwArray Nclose(int nargout, mwVarargin varargin) {
    mwArray st = mwArray::UNDEFINED;
    st = Mclose(nargout, varargin.ToArray());
    return st;
}

//
// The function "close" contains the normal interface for the "close"
// M-function from file "c:\matlab6p5\toolbox\matlab\graphics\close.m" (lines
// 1-112). This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
mwArray close(mwVarargin varargin) {
    int nargout = 1;
    mwArray st = mwArray::UNDEFINED;
    st = Mclose(nargout, varargin.ToArray());
    return st;
}

//
// The function "Vclose" contains the void interface for the "close" M-function
// from file "c:\matlab6p5\toolbox\matlab\graphics\close.m" (lines 1-112). The
// void interface is only produced if the M-function uses the special variable
// "nargout", and has at least one output. The void interface function
// specifies zero output arguments to the implementation version of the
// function, and in the event that the implementation version still returns an
// output (which, in MATLAB, would be assigned to the "ans" variable), it
// deallocates the output. This function processes any input arguments and
// passes them to the implementation version of the function, appearing above.
//
void Vclose(mwVarargin varargin) {
    mwArray st = mwArray::UNDEFINED;
    st = Mclose(0, varargin.ToArray());
}

//
// The function "mlxClose" contains the feval interface for the "close"
// M-function from file "c:\matlab6p5\toolbox\matlab\graphics\close.m" (lines
// 1-112). The feval function calls the implementation version of close through
// this function. This function processes any input arguments and passes them
// to the implementation version of the function, appearing above.
//
void mlxClose(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[1];
        mwArray mplhs[1];
        mclCppUndefineArrays(1, mplhs);
        if (nlhs > 1) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: close Line: 1 Column: 1"
                  " The function \"close\" was called with more "
                  "than the declared number of outputs (1).")));
        }
        mprhs[0] = mclCreateVararginCell(nrhs, prhs);
        mplhs[0] = Mclose(nlhs, mprhs[0]);
        plhs[0] = mplhs[0].FreezeData();
    }
    MW_END_MLX();
}

//
// The function "close_request_close" contains the normal interface for the
// "close/request_close" M-function from file
// "c:\matlab6p5\toolbox\matlab\graphics\close.m" (lines 112-154). This
// function processes any input arguments and passes them to the implementation
// version of the function, appearing above.
//
static mwArray close_request_close(mwArray h) {
    int nargout = 1;
    mwArray status = mwArray::UNDEFINED;
    status = Mclose_request_close(nargout, h);
    return status;
}

//
// The function "mlxClose_request_close" contains the feval interface for the
// "close/request_close" M-function from file
// "c:\matlab6p5\toolbox\matlab\graphics\close.m" (lines 112-154). The feval
// function calls the implementation version of close/request_close through
// this function. This function processes any input arguments and passes them
// to the implementation version of the function, appearing above.
//
void mlxClose_request_close(int nlhs,
                            mxArray * plhs[],
                            int nrhs,
                            mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[1];
        mwArray mplhs[1];
        int i;
        mclCppUndefineArrays(1, mplhs);
        if (nlhs > 1) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: close/request_close Line: 112 Col"
                  "umn: 1 The function \"close/request_close\" was called "
                  "with more than the declared number of outputs (1).")));
        }
        if (nrhs > 1) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: close/request_close Line: 112 Col"
                  "umn: 1 The function \"close/request_close\" was called "
                  "with more than the declared number of inputs (1).")));
        }
        for (i = 0; i < 1 && i < nrhs; ++i) {
            mprhs[i] = mwArray(prhs[i], 0);
        }
        for (; i < 1; ++i) {
            mprhs[i].MakeDIN();
        }
        mplhs[0] = Mclose_request_close(nlhs, mprhs[0]);
        plhs[0] = mplhs[0].FreezeData();
    }
    MW_END_MLX();
}

//
// The function "close_checkfigs" contains the normal interface for the
// "close/checkfigs" M-function from file
// "c:\matlab6p5\toolbox\matlab\graphics\close.m" (lines 154-162). This
// function processes any input arguments and passes them to the implementation
// version of the function, appearing above.
//
static mwArray close_checkfigs(mwArray h) {
    int nargout = 1;
    mwArray status = mwArray::UNDEFINED;
    status = Mclose_checkfigs(nargout, h);
    return status;
}

//
// The function "mlxClose_checkfigs" contains the feval interface for the
// "close/checkfigs" M-function from file
// "c:\matlab6p5\toolbox\matlab\graphics\close.m" (lines 154-162). The feval
// function calls the implementation version of close/checkfigs through this
// function. This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
void mlxClose_checkfigs(int nlhs,
                        mxArray * plhs[],
                        int nrhs,
                        mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[1];
        mwArray mplhs[1];
        int i;
        mclCppUndefineArrays(1, mplhs);
        if (nlhs > 1) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: close/checkfigs Line: 154 Colu"
                  "mn: 1 The function \"close/checkfigs\" was called wi"
                  "th more than the declared number of outputs (1).")));
        }
        if (nrhs > 1) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: close/checkfigs Line: 154 Colu"
                  "mn: 1 The function \"close/checkfigs\" was called wi"
                  "th more than the declared number of inputs (1).")));
        }
        for (i = 0; i < 1 && i < nrhs; ++i) {
            mprhs[i] = mwArray(prhs[i], 0);
        }
        for (; i < 1; ++i) {
            mprhs[i].MakeDIN();
        }
        mplhs[0] = Mclose_checkfigs(nlhs, mprhs[0]);
        plhs[0] = mplhs[0].FreezeData();
    }
    MW_END_MLX();
}

//
// The function "Mclose" is the implementation version of the "close"
// M-function from file "c:\matlab6p5\toolbox\matlab\graphics\close.m" (lines
// 1-112). It contains the actual compiled code for that M-function. It is a
// static function and must only be called from one of the interface functions,
// appearing below.
//
//
// function st = close(varargin)
//
static mwArray Mclose(int nargout_, mwArray varargin) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_close;
    int nargin_ = nargin(-1, mwVarargin(varargin));
    mwArray st = mwArray::UNDEFINED;
    mwArray sfFigs = mwArray::UNDEFINED;
    mwArray hhmode = mwArray::UNDEFINED;
    mwArray ans = mwArray::UNDEFINED;
    mwArray num = mwArray::UNDEFINED;
    mwArray hlist = mwArray::UNDEFINED;
    mwArray cur_arg = mwArray::UNDEFINED;
    mwArray i = mwArray::UNDEFINED;
    mwArray status = mwArray::UNDEFINED;
    mwArray closeHidden = mwArray::UNDEFINED;
    mwArray closeForce = mwArray::UNDEFINED;
    mwArray closeAll = mwArray::UNDEFINED;
    mwArray h = mwArray::UNDEFINED;
    //
    // %CLOSE  Close figure.
    // %   CLOSE(H) closes the window with handle H.
    // %   CLOSE, by itself, closes the current figure window.
    // %
    // %   CLOSE('name') closes the named window.
    // %
    // %   CLOSE ALL  closes all the open figure windows.
    // %   CLOSE ALL HIDDEN  closes hidden windows as well.
    // %   
    // %   STATUS = CLOSE(...) returns 1 if the specified windows were closed
    // %   and 0 otherwise.
    // %
    // %   See also DELETE.
    // 
    // %   CLOSE ALL FORCE  unconditionally closes all windows by deleting them
    // %   without executing the close request function.
    // 
    // %   Copyright 1984-2002 The MathWorks, Inc.
    // %   $Revision: 5.42 $  $Date: 2002/04/08 22:41:27 $
    // %   J.N. Little 1-7-92
    // 
    // h = [];
    //
    h = _mxarray0_;
    //
    // closeAll = 0;
    //
    closeAll = _mxarray1_;
    //
    // closeForce = 0;
    //
    closeForce = _mxarray1_;
    //
    // closeHidden = 0;
    //
    closeHidden = _mxarray1_;
    //
    // status = 1;
    //
    status = _mxarray2_;
    //
    // 
    // if nargin == 0
    //
    if (nargin_ == 0) {
        //
        // h = get(0,'Children');
        //
        h = Nget(1, mwVarargin(_mxarray1_, _mxarray3_));
        //
        // if ~isempty(h)
        //
        if (mclNotBool(isempty(mwVv(h, "h")))) {
            //
            // h = gcf;
            //
            h = gcf();
        //
        // end
        //
        }
    //
    // else
    //
    } else {
        //
        // % Input can be <handle>, '<handle>', 'force', and/or 'all' in any order
        // for i=1:nargin
        //
        int v_ = mclForIntStart(1);
        int e_ = nargin_;
        if (v_ > e_) {
            i = _mxarray0_;
        } else {
            //
            // cur_arg = varargin{i};
            // 
            // if isstr(cur_arg)
            // switch lower(cur_arg)
            // case 'force', 
            // closeForce = 1;
            // case 'all',
            // closeAll   = 1;
            // case 'hidden',
            // closeHidden = 1;
            // case 'gcf',
            // h = [h gcf];
            // case 'gcbf',
            // h = [h gcbf];
            // otherwise
            // %Find Figure with given name, or it is command style call
            // hlist = findobj(get(0,'children'),'flat','name',cur_arg);
            // if ~isempty(hlist)
            // h = [h hlist];
            // else
            // num = str2double(cur_arg);
            // if ~isnan(num)
            // h = [h num];
            // end
            // end
            // end
            // else
            // h = [h cur_arg];
            // if isempty(h),  % make sure close([]) does nothing:
            // if nargout==1, st = status; end
            // return
            // end 
            // end
            // end
            //
            for (; ; ) {
                cur_arg = mwVa(varargin, "varargin").cell(v_);
                if (tobool(isstr(mwVv(cur_arg, "cur_arg")))) {
                    mwArray v_0 = lower(mwVv(cur_arg, "cur_arg"));
                    if (switchcompare(v_0, _mxarray5_)) {
                        closeForce = _mxarray2_;
                    } else if (switchcompare(v_0, _mxarray7_)) {
                        closeAll = _mxarray2_;
                    } else if (switchcompare(v_0, _mxarray9_)) {
                        closeHidden = _mxarray2_;
                    } else if (switchcompare(v_0, _mxarray11_)) {
                        h = horzcat(mwVarargin(mwVv(h, "h"), gcf()));
                    } else if (switchcompare(v_0, _mxarray13_)) {
                        h = horzcat(mwVarargin(mwVv(h, "h"), gcbf()));
                    } else {
                        hlist
                          = findobj(
                              mwVarargin(
                                Nget(1, mwVarargin(_mxarray1_, _mxarray15_)),
                                _mxarray17_,
                                _mxarray19_,
                                mwVv(cur_arg, "cur_arg")));
                        if (mclNotBool(isempty(mwVv(hlist, "hlist")))) {
                            h
                              = horzcat(
                                  mwVarargin(
                                    mwVv(h, "h"), mwVv(hlist, "hlist")));
                        } else {
                            num = str2double(mwVv(cur_arg, "cur_arg"));
                            if (mclNotBool(isnan(mwVv(num, "num")))) {
                                h
                                  = horzcat(
                                      mwVarargin(
                                        mwVv(h, "h"), mwVv(num, "num")));
                            }
                        }
                    }
                } else {
                    h
                      = horzcat(
                          mwVarargin(mwVv(h, "h"), mwVv(cur_arg, "cur_arg")));
                    if (tobool(isempty(mwVv(h, "h")))) {
                        if (nargout_ == 1) {
                            st = mwVv(status, "status");
                        }
                        goto return_;
                    }
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            i = v_;
        }
        //
        // 
        // % If h is empty that this point, define it by context.
        // if isempty(h)
        //
        if (tobool(isempty(mwVv(h, "h")))) {
            //
            // % If there were other args besides the special ones, error out 
            // if (closeHidden + closeForce + closeAll) < nargin
            //
            if (mclLtBool(
                  mwVv(closeHidden, "closeHidden")
                  + mwVv(closeForce, "closeForce")
                  + mwVv(closeAll, "closeAll"),
                  nargin_)) {
                //
                // error('Specified window does not exist.');
                //
                error(mwVarargin(_mxarray21_));
            //
            // end
            //
            }
            //
            // if closeHidden | closeForce
            //
            {
                mwArray a_ = mwVv(closeHidden, "closeHidden");
                if (tobool(a_) || tobool(a_ | mwVv(closeForce, "closeForce"))) {
                    //
                    // hhmode = get(0,'showhiddenhandles');
                    //
                    hhmode = Nget(1, mwVarargin(_mxarray1_, _mxarray23_));
                    //
                    // set(0,'showhiddenhandles','on');
                    //
                    ans.EqAns(
                      Nset(
                        0, mwVarargin(_mxarray1_, _mxarray23_, _mxarray25_)));
                } else {
                }
            //
            // end
            //
            }
            //
            // if closeAll
            //
            if (tobool(mwVv(closeAll, "closeAll"))) {
                //
                // h = findobj(get(0,'Children'), 'flat','type','figure');
                //
                h
                  = findobj(
                      mwVarargin(
                        Nget(1, mwVarargin(_mxarray1_, _mxarray3_)),
                        _mxarray17_,
                        _mxarray27_,
                        _mxarray29_));
                //
                // sfFigs = findobj(h, 'Tag', 'SFCHART');
                //
                sfFigs
                  = findobj(
                      mwVarargin(mwVv(h, "h"), _mxarray31_, _mxarray33_));
                //
                // sfFigs = [sfFigs; findobj(h, 'Tag', 'DEFAULT_SFCHART')];
                //
                sfFigs
                  = vertcat(
                      mwVarargin(
                        mwVv(sfFigs, "sfFigs"),
                        findobj(
                          mwVarargin(
                            mwVv(h, "h"), _mxarray31_, _mxarray35_))));
                //
                // sfFigs = [sfFigs; findobj(h, 'Tag', 'SFEXPLR')];
                //
                sfFigs
                  = vertcat(
                      mwVarargin(
                        mwVv(sfFigs, "sfFigs"),
                        findobj(
                          mwVarargin(
                            mwVv(h, "h"), _mxarray31_, _mxarray37_))));
                //
                // sfFigs = [sfFigs; findobj(h, 'Tag', 'SF_DEBUGGER')];
                //
                sfFigs
                  = vertcat(
                      mwVarargin(
                        mwVv(sfFigs, "sfFigs"),
                        findobj(
                          mwVarargin(
                            mwVv(h, "h"), _mxarray31_, _mxarray39_))));
                //
                // sfFigs = [sfFigs; findobj(h, 'Tag', 'SF_SAFEHOUSE')];
                //
                sfFigs
                  = vertcat(
                      mwVarargin(
                        mwVv(sfFigs, "sfFigs"),
                        findobj(
                          mwVarargin(
                            mwVv(h, "h"), _mxarray31_, _mxarray41_))));
                //
                // sfFigs = [sfFigs; findobj(h, 'Tag', 'SF_SNR')];
                //
                sfFigs
                  = vertcat(
                      mwVarargin(
                        mwVv(sfFigs, "sfFigs"),
                        findobj(
                          mwVarargin(
                            mwVv(h, "h"), _mxarray31_, _mxarray43_))));
                //
                // h = setdiff(h,sfFigs);
                //
                h = Nsetdiff(1, NULL, mwVv(h, "h"), mwVv(sfFigs, "sfFigs"));
            //
            // else
            //
            } else {
                //
                // h = gcf;
                //
                h = gcf();
            //
            // end
            //
            }
            //
            // if closeHidden | closeForce
            //
            {
                mwArray a_ = mwVv(closeHidden, "closeHidden");
                if (tobool(a_) || tobool(a_ | mwVv(closeForce, "closeForce"))) {
                    //
                    // set(0,'showhiddenhandles',hhmode)
                    //
                    ans.EqPrintAns(
                      Nset(
                        0,
                        mwVarargin(
                          _mxarray1_, _mxarray23_, mwVv(hhmode, "hhmode"))));
                } else {
                }
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
    //
    // 
    // if ~checkfigs(h), error('Invalid figure handle.'); end
    //
    if (mclNotBool(close_checkfigs(mwVv(h, "h")))) {
        error(mwVarargin(_mxarray45_));
    }
    //
    // 
    // if closeForce
    //
    if (tobool(mwVv(closeForce, "closeForce"))) {
        //
        // delete(h)
        //
        delete_func(mwVarargin(mwVv(h, "h")));
    //
    // else
    //
    } else {
        //
        // status = request_close(h);
        //
        status = close_request_close(mwVv(h, "h"));
    //
    // end
    //
    }
    //
    // 
    // if nargout==1, st = status; end
    //
    if (nargout_ == 1) {
        st = mwVv(status, "status");
    }
    //
    // 
    // 
    // %------------------------------------------------
    //
    return_:
    mwValidateOutput(st, 1, nargout_, "st", "close");
    return st;
}

//
// The function "Mclose_request_close" is the implementation version of the
// "close/request_close" M-function from file
// "c:\matlab6p5\toolbox\matlab\graphics\close.m" (lines 112-154). It contains
// the actual compiled code for that M-function. It is a static function and
// must only be called from one of the interface functions, appearing below.
//
//
// function status = request_close(h)
//
static mwArray Mclose_request_close(int nargout_, mwArray h) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_close;
    mwArray status = mwArray::UNDEFINED;
    mwArray ws = mwArray::UNDEFINED;
    mwArray crf = mwArray::UNDEFINED;
    mwArray lp = mwArray::UNDEFINED;
    mwArray waserr = mwArray::UNDEFINED;
    mwArray hhmode = mwArray::UNDEFINED;
    mwArray numFig = mwArray::UNDEFINED;
    mwArray ans = mwArray::UNDEFINED;
    //
    // persistent in_request_close;
    // status = 1;
    //
    status = _mxarray2_;
    //
    // numFig=length(h);
    //
    numFig = mclLengthInt(mwVa(h, "h"));
    //
    // hhmode = get(0,'showhiddenhandles');
    //
    hhmode = Nget(1, mwVarargin(_mxarray1_, _mxarray23_));
    //
    // set(0,'showhiddenhandles','on')
    //
    ans.EqPrintAns(Nset(0, mwVarargin(_mxarray1_, _mxarray23_, _mxarray25_)));
    //
    // waserr=0;
    //
    waserr = _mxarray1_;
    //
    // for lp = 1:numFig,
    //
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mwVv(numFig, "numFig"));
        if (v_ > e_) {
            lp = _mxarray0_;
        } else {
            //
            // if ishandle(h(lp))
            // set(0,'CurrentFigure',h(lp));
            // crf = get(h(lp),'CloseRequestFcn');
            // % prevent recursion
            // if (in_request_close)
            // ws = warning('on');
            // warning('A callback recursively calls CLOSE.  Use DELETE to prevent this message.')
            // warning(ws);
            // delete(h)
            // in_request_close = 0;
            // else
            // try
            // in_request_close = 1;
            // if ischar(crf)
            // eval(crf)
            // elseif iscell(crf)
            // % fcn pointer call backs are called like this
            // %     fcn     obj   evd  other args      
            // feval(crf{1}, h(lp), [], crf{2:end});
            // elseif isa(crf,'function_handle')
            // feval(crf, h(lp), [])
            // end
            // in_request_close = 0;
            // catch
            // in_request_close = 0;
            // error(sprintf('Error while evaluating figure CloseRequestFcn\n\n%s', lasterr));
            // end
            // end
            // end
            // if ishandle(h(lp)), status = 0; end
            // end
            //
            for (; ; ) {
                if (tobool(ishandle(mclIntArrayRef(mwVa(h, "h"), v_)))) {
                    ans.EqAns(
                      Nset(
                        0,
                        mwVarargin(
                          _mxarray1_,
                          _mxarray47_,
                          mclIntArrayRef(mwVa(h, "h"), v_))));
                    crf
                      = Nget(
                          1,
                          mwVarargin(
                            mclIntArrayRef(mwVa(h, "h"), v_), _mxarray49_));
                    if (tobool(
                          mwVv(
                            _persistent_close_request_close__in_request_close,
                            "in_request_close"))) {
                        ws = Nwarning(1, NULL, mwVarargin(_mxarray25_));
                        ans.EqPrintAns(
                          Nwarning(0, NULL, mwVarargin(_mxarray51_)));
                        ans.EqAns(
                          Nwarning(0, NULL, mwVarargin(mwVv(ws, "ws"))));
                        delete_func(mwVarargin(mwVa(h, "h")));
                        _persistent_close_request_close__in_request_close
                          = _mxarray1_;
                    } else {
                        try {
                            _persistent_close_request_close__in_request_close
                              = _mxarray2_;
                            if (tobool(ischar(mwVv(crf, "crf")))) {
                                ans.EqPrintAns(
                                  eval(mwAnsVarargout(), mwVv(crf, "crf")));
                            } else if (tobool(iscell(mwVv(crf, "crf")))) {
                                ans.EqAns(
                                  feval(
                                    mwAnsVarargout(),
                                    mwVarargin(
                                      mwVv(crf, "crf").cell(_mxarray2_),
                                      mclIntArrayRef(mwVa(h, "h"), v_),
                                      _mxarray0_,
                                      mwVv(crf, "crf").cell(
                                        colon(
                                          _mxarray53_,
                                          end(
                                            mwVv(crf, "crf"),
                                            _mxarray2_,
                                            _mxarray2_))))));
                            } else if (tobool(
                                         isa(mwVv(crf, "crf"), _mxarray54_))) {
                                ans.EqPrintAns(
                                  feval(
                                    mwAnsVarargout(),
                                    mwVarargin(
                                      mwVv(crf, "crf"),
                                      mclIntArrayRef(mwVa(h, "h"), v_),
                                      _mxarray0_)));
                            }
                            _persistent_close_request_close__in_request_close
                              = _mxarray1_;
                        } catch(mwException e_) {
                            _persistent_close_request_close__in_request_close
                              = _mxarray1_;
                            error(
                              mwVarargin(
                                sprintf(
                                  _mxarray56_,
                                  mwVarargin(lasterr(mwArray::DIN)))));
                        }
                    }
                }
                if (tobool(ishandle(mclIntArrayRef(mwVa(h, "h"), v_)))) {
                    status = _mxarray1_;
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            lp = v_;
        }
    }
    //
    // set(0,'showhiddenhandles',hhmode);
    //
    ans.EqAns(
      Nset(0, mwVarargin(_mxarray1_, _mxarray23_, mwVv(hhmode, "hhmode"))));
    mwValidateOutput(status, 1, nargout_, "status", "close/request_close");
    return status;
    //
    // 
    // %------------------------------------------------
    //
}

//
// The function "Mclose_checkfigs" is the implementation version of the
// "close/checkfigs" M-function from file
// "c:\matlab6p5\toolbox\matlab\graphics\close.m" (lines 154-162). It contains
// the actual compiled code for that M-function. It is a static function and
// must only be called from one of the interface functions, appearing below.
//
//
// function status = checkfigs(h)
//
static mwArray Mclose_checkfigs(int nargout_, mwArray h) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_close;
    mwArray status = mwArray::UNDEFINED;
    mwArray i = mwArray::UNDEFINED;
    //
    // status = 1;
    //
    status = _mxarray2_;
    //
    // for i=1:length(h)
    //
    {
        int v_ = mclForIntStart(1);
        int e_ = mclLengthInt(mwVa(h, "h"));
        if (v_ > e_) {
            i = _mxarray0_;
        } else {
            //
            // if ~ishandle(h(i)) | ~strcmp(get(h(i),'type'),'figure')
            // status = 0;
            // return
            // end
            // end
            //
            for (; ; ) {
                mwArray a_ = ~ ishandle(mclIntArrayRef(mwVa(h, "h"), v_));
                if (tobool(a_)
                    || tobool(
                         a_
                         | ~ strcmp(
                               Nget(
                                 1,
                                 mwVarargin(
                                   mclIntArrayRef(mwVa(h, "h"), v_),
                                   _mxarray27_)),
                               _mxarray29_))) {
                    status = _mxarray1_;
                    goto return_;
                } else {
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            i = v_;
        }
    }
    return_:
    mwValidateOutput(status, 1, nargout_, "status", "close/checkfigs");
    return status;
}
