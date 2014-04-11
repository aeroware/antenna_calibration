//
// MATLAB Compiler: 3.0
// Date: Wed Jul 14 15:58:49 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "test2" 
//
#include "varsave.hpp"
#include "libmatlbm.hpp"
#include "libmmfile.hpp"
#include "mkdir.hpp"

static mxChar _array1_[1] = { '_' };
static mwArray _mxarray0_ = mclInitializeString(1, _array1_);
static mwArray _mxarray2_ = mclInitializeDouble(1.0);

static mxChar _array4_[1] = { 'x' };
static mwArray _mxarray3_ = mclInitializeString(1, _array4_);
static mwArray _mxarray5_ = mclInitializeDoubleVector(0, 0, (double *)NULL);

static mxChar _array7_[3] = { 'd', 'i', 'r' };
static mwArray _mxarray6_ = mclInitializeString(3, _array7_);

static mxChar _array9_[4] = { '.', 'm', 'a', 't' };
static mwArray _mxarray8_ = mclInitializeString(4, _array9_);

static mxChar _array11_[4] = { '%', '0', '6', 'd' };
static mwArray _mxarray10_ = mclInitializeString(4, _array11_);

static mxChar _array13_[3] = { '=', 'v', ';' };
static mwArray _mxarray12_ = mclInitializeString(3, _array13_);

static mxChar _array15_[4] = { 'f', 'i', 'l', 'e' };
static mwArray _mxarray14_ = mclInitializeString(4, _array15_);

static mxChar _array17_[50] = { 'V', 'a', 'r', 'i', 'a', 'b', 'l', 'e', '-',
                                ' ', 'a', 'n', 'd', ' ', 'n', 'u', 'm', 'b',
                                'e', 'r', '-', 'a', 'r', 'r', 'a', 'y', ' ',
                                'm', 'u', 's', 't', ' ', 'b', 'e', ' ', 'o',
                                'f', ' ', 's', 'a', 'm', 'e', ' ', 'l', 'e',
                                'n', 'g', 't', 'h', '.' };
static mwArray _mxarray16_ = mclInitializeString(50, _array17_);

static mxChar _array19_[6] = { '=', 'v', '(', 'k', ')', ';' };
static mwArray _mxarray18_ = mclInitializeString(6, _array19_);

static mxChar _array21_[8] = { '%', '0', '6', 'd', '.', 'm', 'a', 't' };
static mwArray _mxarray20_ = mclInitializeString(8, _array21_);

static mxChar _array23_[1] = { 'v' };
static mwArray _mxarray22_ = mclInitializeString(1, _array23_);

static mxChar _array25_[2] = { 'v', 'v' };
static mwArray _mxarray24_ = mclInitializeString(2, _array25_);

static mxChar _array27_[1] = { '=' };
static mwArray _mxarray26_ = mclInitializeString(1, _array27_);

static mxChar _array29_[4] = { '(', 'k', ')', ';' };
static mwArray _mxarray28_ = mclInitializeString(4, _array29_);

void InitializeModule_varsave() {
}

void TerminateModule_varsave() {
}

static void Mvarsave(mwArray f,
                     mwArray v,
                     mwArray n,
                     mwArray VarName,
                     mwArray OneFile);

_mexLocalFunctionTable _local_function_table_varsave
  = { 0, (mexFunctionTableEntry *)NULL };

//
// The function "varsave" contains the normal interface for the "varsave"
// M-function from file "c:\matlab6p5\work\asap\_sat\_sat\varsave.m" (lines
// 1-103). This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
void varsave(mwArray f,
             mwArray v,
             mwArray n,
             mwArray VarName,
             mwArray OneFile) {
    Mvarsave(f, v, n, VarName, OneFile);
}

//
// The function "mlxVarsave" contains the feval interface for the "varsave"
// M-function from file "c:\matlab6p5\work\asap\_sat\_sat\varsave.m" (lines
// 1-103). The feval function calls the implementation version of varsave
// through this function. This function processes any input arguments and
// passes them to the implementation version of the function, appearing above.
//
void mlxVarsave(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[5];
        int i;
        if (nlhs > 0) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: varsave Line: 2 Column: "
                  "1 The function \"varsave\" was called with mor"
                  "e than the declared number of outputs (0).")));
        }
        if (nrhs > 5) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: varsave Line: 2 Column: "
                  "1 The function \"varsave\" was called with mor"
                  "e than the declared number of inputs (5).")));
        }
        for (i = 0; i < 5 && i < nrhs; ++i) {
            mprhs[i] = mwArray(prhs[i], 0);
        }
        for (; i < 5; ++i) {
            mprhs[i].MakeDIN();
        }
        Mvarsave(mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    }
    MW_END_MLX();
}

//
// The function "Mvarsave" is the implementation version of the "varsave"
// M-function from file "c:\matlab6p5\work\asap\_sat\_sat\varsave.m" (lines
// 1-103). It contains the actual compiled code for that M-function. It is a
// static function and must only be called from one of the interface functions,
// appearing below.
//
//
// 
// function VarSave(f,v,n,VarName,OneFile)
//
static void Mvarsave(mwArray f,
                     mwArray v,
                     mwArray n,
                     mwArray VarName,
                     mwArray OneFile) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_varsave;
    int nargin_ = nargin(5, mwVarargin(f, v, n, VarName, OneFile));
    mwArray vv = mwArray::UNDEFINED;
    mwArray VarName0 = mwArray::UNDEFINED;
    mwArray vn = mwArray::UNDEFINED;
    mwArray k = mwArray::UNDEFINED;
    mwArray ans = mwArray::UNDEFINED;
    mwArray ff = mwArray::UNDEFINED;
    mwArray m = mwArray::UNDEFINED;
    mwArray p = mwArray::UNDEFINED;
    mwArray s = mwArray::UNDEFINED;
    mwArray ex = mwArray::UNDEFINED;
    mwArray na = mwArray::UNDEFINED;
    mwArray pa = mwArray::UNDEFINED;
    mwArray Delimiter = mwArray::UNDEFINED;
    //
    // 
    // % VarSave(f,v,n,VarName) writes v to the file f using variable name
    // % VarName or VarName_n: If n is an array, v must be an array of same size; 
    // % in this case each element of v is stored in an own variable, VarName_n, 
    // % uniquely identified by the numbers n. If n is scalar, v is saved as a 
    // % whole in VarName_n; if n is not defined, no numbers are added to the VarName.
    // % 
    // % VarSave(f,v,n,VarName,0) writes elements of v to separate files, 
    // % appending _n to the filename f, so the filenames identify the various stored 
    // % variables and the same variable name VarName is used in all saved files.
    // %
    // % n must be integer <=999999.
    // %
    // % Defaults: n=[] (no numbers appended), VarName='x'.
    // %
    // % Extensions of f are substituted by the extension 'mat'.
    // 
    // Delimiter='_';  % used as delimiter prior to the number n
    //
    Delimiter = _mxarray0_;
    //
    // 
    // if (nargin<5)|isempty(OneFile),
    //
    {
        mwArray a_ = nargin_ < 5;
        if (tobool(a_) || tobool(a_ | isempty(mwVa(OneFile, "OneFile")))) {
            //
            // OneFile=1;
            //
            OneFile = _mxarray2_;
        } else {
        }
    //
    // end
    //
    }
    //
    // 
    // if (nargin<4)|isempty(VarName),
    //
    {
        mwArray a_ = nargin_ < 4;
        if (tobool(a_) || tobool(a_ | isempty(mwVa(VarName, "VarName")))) {
            //
            // VarName='x';
            //
            VarName = _mxarray3_;
        } else {
        }
    //
    // end
    //
    }
    //
    // 
    // if nargin<3,
    //
    if (nargin_ < 3) {
        //
        // n=[];
        //
        n = _mxarray5_;
    //
    // end
    //
    }
    //
    // 
    // [pa,na,ex]=fileparts(f);
    //
    pa = fileparts(&na, &ex, mwVa(f, "f"));
    //
    // if ~exist(pa,'dir')&~isempty(pa),
    //
    {
        mwArray a_ = ~ exist(mwVv(pa, "pa"), _mxarray6_);
        if (tobool(a_) && tobool(a_ & ~ isempty(mwVv(pa, "pa")))) {
            //
            // s=mkdir(pa);
            //
            s = Nmkdir(0, mwValueVarargout(), mwVarargin(mwVv(pa, "pa")));
        } else {
        }
    //
    // end
    //
    }
    //
    // 
    // p=prod(size(n));
    //
    p = prod(size(mwValueVarargout(), mwVa(n, "n")));
    //
    // m=prod(size(v));
    //
    m = prod(size(mwValueVarargout(), mwVa(v, "v")));
    //
    // 
    // if OneFile, % all variables in one file
    //
    if (tobool(mwVa(OneFile, "OneFile"))) {
        //
        // 
        // ff=fullfile(pa,[na,'.mat']);
        //
        ff
          = fullfile(
              mwVarargin(
                mwVv(pa, "pa"),
                horzcat(mwVarargin(mwVv(na, "na"), _mxarray8_))));
        //
        // 
        // if isempty(n)|isequal(p,1),
        //
        {
            mwArray a_ = isempty(mwVa(n, "n"));
            if (tobool(a_)
                || tobool(
                     a_ | isequal(mwVv(p, "p"), mwVarargin(_mxarray2_)))) {
                //
                // if ~isempty(n),
                //
                if (mclNotBool(isempty(mwVa(n, "n")))) {
                    //
                    // VarName=[VarName,Delimiter,num2str(n,'%06d')];
                    //
                    VarName
                      = horzcat(
                          mwVarargin(
                            mwVa(VarName, "VarName"),
                            mwVv(Delimiter, "Delimiter"),
                            num2str(mwVa(n, "n"), _mxarray10_)));
                //
                // end
                //
                }
                //
                // eval([VarName,'=v;']);
                //
                ans.EqAns(
                  eval(
                    mwAnsVarargout(),
                    horzcat(
                      mwVarargin(mwVa(VarName, "VarName"), _mxarray12_))));
                //
                // if exist(ff,'file'),
                //
                if (tobool(exist(mwVv(ff, "ff"), _mxarray14_))) {
                    //
                    // save(ff,VarName,'-append');
                    //
                    error(
                      mwVarargin(
                        mwArray("MATLAB:binder_rterror_save_no_strings"),
                        mwArray(
                          "Run-time Error: File: c:\\matlab6p5\\work\\asap\\"
                          "_sat\\_sat\\varsave.m Line: 52 Column: 15 The sav"
                          "e statement did not specifically list the names o"
                          "f variables to be saved as constant strings.")));
                    mwArray::DIN;
                //
                // else
                //
                } else {
                    //
                    // save(ff,VarName);
                    //
                    error(
                      mwVarargin(
                        mwArray("MATLAB:binder_rterror_save_no_strings"),
                        mwArray(
                          "Run-time Error: File: c:\\matlab6p5\\work\\asap\\"
                          "_sat\\_sat\\varsave.m Line: 54 Column: 15 The sav"
                          "e statement did not specifically list the names o"
                          "f variables to be saved as constant strings.")));
                    mwArray::DIN;
                //
                // end
                //
                }
                //
                // return
                //
                goto return_;
            } else {
            }
        //
        // end
        //
        }
        //
        // 
        // if m~=p,
        //
        if (mclNeBool(mwVv(m, "m"), mwVv(p, "p"))) {
            //
            // error('Variable- and number-array must be of same length.');
            //
            error(mwVarargin(_mxarray16_));
        //
        // end
        //
        }
        //
        // 
        // for k=1:m,
        //
        {
            int v_ = mclForIntStart(1);
            int e_ = mclForIntEnd(mwVv(m, "m"));
            if (v_ > e_) {
                k = _mxarray5_;
            } else {
                //
                // vn=[VarName,Delimiter,num2str(n(k),'%06d')];
                // eval([vn,'=v(k);']);
                // if exist(ff,'file'),
                // save(ff,vn,'-append');
                // else
                // save(ff,vn);
                // end
                // 
                // end
                //
                for (; ; ) {
                    vn
                      = horzcat(
                          mwVarargin(
                            mwVa(VarName, "VarName"),
                            mwVv(Delimiter, "Delimiter"),
                            num2str(
                              mclIntArrayRef(mwVa(n, "n"), v_), _mxarray10_)));
                    ans.EqAns(
                      eval(
                        mwAnsVarargout(),
                        horzcat(mwVarargin(mwVv(vn, "vn"), _mxarray18_))));
                    if (tobool(exist(mwVv(ff, "ff"), _mxarray14_))) {
                        error(
                          mwVarargin(
                            mwArray("MATLAB:binder_rterror_save_no_strings"),
                            mwArray(
                              "Run-time Error: File: c:\\matlab6p5\\wo"
                              "rk\\asap\\_sat\\_sat\\varsave.m Line: 6"
                              "7 Column: 15 The save statement did not"
                              " specifically list the names of variabl"
                              "es to be saved as constant strings.")));
                        mwArray::DIN;
                    } else {
                        error(
                          mwVarargin(
                            mwArray("MATLAB:binder_rterror_save_no_strings"),
                            mwArray(
                              "Run-time Error: File: c:\\matlab6p5\\wo"
                              "rk\\asap\\_sat\\_sat\\varsave.m Line: 6"
                              "9 Column: 15 The save statement did not"
                              " specifically list the names of variabl"
                              "es to be saved as constant strings.")));
                        mwArray::DIN;
                    }
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                k = v_;
            }
        }
    //
    // 
    // else % each variable stored into an own file
    //
    } else {
        //
        // 
        // if isempty(n)|isequal(p,1),
        //
        mwArray a_ = isempty(mwVa(n, "n"));
        if (tobool(a_)
            || tobool(a_ | isequal(mwVv(p, "p"), mwVarargin(_mxarray2_)))) {
            //
            // if isempty(n), 
            //
            if (tobool(isempty(mwVa(n, "n")))) {
                //
                // ff=fullfile(pa,[na,'.mat']);
                //
                ff
                  = fullfile(
                      mwVarargin(
                        mwVv(pa, "pa"),
                        horzcat(mwVarargin(mwVv(na, "na"), _mxarray8_))));
            //
            // else
            //
            } else {
                //
                // ff=fullfile(pa,[na,Delimiter,num2str(n,'%06d.mat')]);
                //
                ff
                  = fullfile(
                      mwVarargin(
                        mwVv(pa, "pa"),
                        horzcat(
                          mwVarargin(
                            mwVv(na, "na"),
                            mwVv(Delimiter, "Delimiter"),
                            num2str(mwVa(n, "n"), _mxarray20_)))));
            //
            // end
            //
            }
            //
            // eval([VarName,'=v;']);
            //
            ans.EqAns(
              eval(
                mwAnsVarargout(),
                horzcat(mwVarargin(mwVa(VarName, "VarName"), _mxarray12_))));
            //
            // save(ff,VarName);
            //
            error(
              mwVarargin(
                mwArray("MATLAB:binder_rterror_save_no_strings"),
                mwArray(
                  "Run-time Error: File: c:\\matlab6p5\\work\\asap\\"
                  "_sat\\_sat\\varsave.m Line: 83 Column: 13 The sav"
                  "e statement did not specifically list the names o"
                  "f variables to be saved as constant strings.")));
            mwArray::DIN;
            //
            // return
            //
            goto return_;
        } else {
        }
        //
        // end
        // 
        // if m~=p,
        //
        if (mclNeBool(mwVv(m, "m"), mwVv(p, "p"))) {
            //
            // error('Variable- and number-array must be of same length.');
            //
            error(mwVarargin(_mxarray16_));
        //
        // end
        //
        }
        //
        // 
        // VarName0='v';
        //
        VarName0 = _mxarray22_;
        //
        // if isequal(VarName,VarName0),
        //
        if (tobool(
              isequal(
                mwVa(VarName, "VarName"),
                mwVarargin(mwVv(VarName0, "VarName0"))))) {
            //
            // VarName0='vv';
            //
            VarName0 = _mxarray24_;
            //
            // vv=v;
            //
            vv = mwVa(v, "v");
        //
        // end
        //
        }
        //
        // 
        // for k=1:m,
        //
        {
            int v_ = mclForIntStart(1);
            int e_ = mclForIntEnd(mwVv(m, "m"));
            if (v_ > e_) {
                k = _mxarray5_;
            } else {
                //
                // ff=fullfile(pa,[na,Delimiter,num2str(n(k),'%06d.mat')]);
                // eval([VarName,'=',VarName0,'(k);']);
                // save(ff,VarName);
                // end
                //
                for (; ; ) {
                    ff
                      = fullfile(
                          mwVarargin(
                            mwVv(pa, "pa"),
                            horzcat(
                              mwVarargin(
                                mwVv(na, "na"),
                                mwVv(Delimiter, "Delimiter"),
                                num2str(
                                  mclIntArrayRef(mwVa(n, "n"), v_),
                                  _mxarray20_)))));
                    ans.EqAns(
                      eval(
                        mwAnsVarargout(),
                        horzcat(
                          mwVarargin(
                            mwVa(VarName, "VarName"),
                            _mxarray26_,
                            mwVv(VarName0, "VarName0"),
                            _mxarray28_))));
                    error(
                      mwVarargin(
                        mwArray("MATLAB:binder_rterror_save_no_strings"),
                        mwArray(
                          "Run-time Error: File: c:\\matlab6p5\\work\\asap\\"
                          "_sat\\_sat\\varsave.m Line: 100 Column: 13 The sa"
                          "ve statement did not specifically list the names "
                          "of variables to be saved as constant strings.")));
                    mwArray::DIN;
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                k = v_;
            }
        }
    //
    // 
    // end
    //
    }
    return_:;
}
