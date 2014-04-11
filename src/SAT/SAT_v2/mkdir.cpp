//
// MATLAB Compiler: 3.0
// Date: Wed Jul 14 15:58:49 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "test2" 
//
#include "mkdir.hpp"
#include "mwservices.h"
#include "general_private_cdsafewindir.hpp"
#include "libmatlbm.hpp"
#include "libmmfile.hpp"
#include "strread.hpp"
static mwArray _mxarray0_ = mclInitializeDouble(1.0);
static mwArray _mxarray1_ = mclInitializeDouble(2.0);

static mxChar _array3_[35] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 'M', 'K',
                               'D', 'I', 'R', ':', 'N', 'u', 'm', 'b', 'e',
                               'r', 'O', 'f', 'I', 'n', 'p', 'u', 't', 'A',
                               'r', 'g', 'u', 'm', 'e', 'n', 't', 's' };
static mwArray _mxarray2_ = mclInitializeString(35, _array3_);

static mxChar _array5_[25] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 'M', 'K',
                               'D', 'I', 'R', ':', 'A', 'r', 'g', 'u', 'm',
                               'e', 'n', 't', 'T', 'y', 'p', 'e' };
static mwArray _mxarray4_ = mclInitializeString(25, _array5_);

static mxChar _array7_[25] = { 'A', 'r', 'g', 'u', 'm', 'e', 'n', 't', 's',
                               ' ', 'm', 'u', 's', 't', ' ', 'b', 'e', ' ',
                               's', 't', 'r', 'i', 'n', 'g', 's' };
static mwArray _mxarray6_ = mclInitializeString(25, _array7_);
static mwArray _mxarray8_ = mclInitializeDouble(-1.0);
static mwArray _mxarray9_ = mclInitializeDouble(3.0);

static mxChar _array11_[36] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 'M', 'K',
                                'D', 'I', 'R', ':', 'N', 'u', 'm', 'b', 'e',
                                'r', 'O', 'f', 'O', 'u', 't', 'p', 'u', 't',
                                'A', 'r', 'g', 'u', 'm', 'e', 'n', 't', 's' };
static mwArray _mxarray10_ = mclInitializeString(36, _array11_);
static mwArray _mxarray12_ = mclInitializeCharVector(0, 0, (mxChar *)NULL);
static mwArray _mxarray13_ = mclInitializeDouble(0.0);

static mxChar _array15_[34] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 'M', 'K',
                                'D', 'I', 'R', ':', 'A', 'r', 'g', 'u', 'm',
                                'e', 'n', 't', 'I', 'n', 'd', 'e', 't', 'e',
                                'r', 'm', 'i', 'n', 'a', 't', 'e' };
static mwArray _mxarray14_ = mclInitializeString(34, _array15_);

static mxChar _array17_[45] = { 'S', 'e', 'c', 'o', 'n', 'd', ' ', 'd', 'i',
                                'r', 'e', 'c', 't', 'o', 'r', 'y', ' ', 'a',
                                'r', 'g', 'u', 'm', 'e', 'n', 't', ' ', 'i',
                                's', ' ', 'a', 'n', ' ', 'e', 'm', 'p', 't',
                                'y', ' ', 's', 't', 'r', 'i', 'n', 'g', '.' };
static mwArray _mxarray16_ = mclInitializeString(45, _array17_);

static mxChar _array19_[4] = { 'p', 'a', 't', 'h' };
static mwArray _mxarray18_ = mclInitializeString(4, _array19_);

static mxChar _array21_[2] = { 0x005c, 0x005c };
static mwArray _mxarray20_ = mclInitializeString(2, _array21_);

static mxChar _array23_[27] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 'M', 'K',
                                'D', 'I', 'R', ':', 'D', 'i', 'r', 'e', 'c',
                                't', 'o', 'r', 'y', 'I', 's', 'U', 'N', 'C' };
static mwArray _mxarray22_ = mclInitializeString(27, _array23_);

static mxChar _array25_[37] = { 'C', 'a', 'n', 'n', 'o', 't', ' ', 'c',
                                'r', 'e', 'a', 't', 'e', ' ', 'U', 'N',
                                'C', ' ', 'd', 'i', 'r', 'e', 'c', 't',
                                'o', 'r', 'y', ' ', 'i', 'n', 's', 'i',
                                'd', 'e', ' ', '%', 's' };
static mwArray _mxarray24_ = mclInitializeString(37, _array25_);

static mxChar _array27_[1] = { ':' };
static mwArray _mxarray26_ = mclInitializeString(1, _array27_);

static mxChar _array29_[41] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 'M', 'K',
                                'D', 'I', 'R', ':', 'D', 'i', 'r', 'e', 'c',
                                't', 'o', 'r', 'y', 'C', 'o', 'n', 't', 'a',
                                'i', 'n', 's', 'D', 'r', 'i', 'v', 'e', 'L',
                                'e', 't', 't', 'e', 'r' };
static mwArray _mxarray28_ = mclInitializeString(41, _array29_);

static mxChar _array31_[42] = { 'C', 'a', 'n', 'n', 'o', 't', ' ', 'c', 'r',
                                'e', 'a', 't', 'e', ' ', 'a', 'b', 's', 'o',
                                'l', 'u', 't', 'e', ' ', 'd', 'i', 'r', 'e',
                                'c', 't', 'o', 'r', 'y', ' ', 'i', 'n', 's',
                                'i', 'd', 'e', ' ', '%', 's' };
static mwArray _mxarray30_ = mclInitializeString(42, _array31_);

static mxChar _array33_[1] = { '"' };
static mwArray _mxarray32_ = mclInitializeString(1, _array33_);

static mxChar _array35_[30] = { 'D', 'i', 'r', 'e', 'c', 't', 'o', 'r',
                                'y', ' ', '"', '%', 's', '"', ' ', 'a',
                                'l', 'r', 'e', 'a', 'd', 'y', ' ', 'e',
                                'x', 'i', 's', 't', 's', '.' };
static mwArray _mxarray34_ = mclInitializeString(30, _array35_);

static mxChar _array37_[28] = { 'M', 'A', 'T', 'L', 'A', 'B', ':',
                                'M', 'K', 'D', 'I', 'R', ':', 'D',
                                'i', 'r', 'e', 'c', 't', 'o', 'r',
                                'y', 'E', 'x', 'i', 's', 't', 's' };
static mwArray _mxarray36_ = mclInitializeString(28, _array37_);

static mxChar _array39_[1] = { 0x005c };
static mwArray _mxarray38_ = mclInitializeString(1, _array39_);

static mxChar _array41_[9] = { 'm', 'k', 'd', 'i', 'r', ' ', '-', 'p', ' ' };
static mwArray _mxarray40_ = mclInitializeString(9, _array41_);

static mxChar _array43_[1] = { '/' };
static mwArray _mxarray42_ = mclInitializeString(1, _array43_);

static mxChar _array45_[20] = { 'M', 'A', 'T', 'L', 'A', 'B', ':',
                                'M', 'K', 'D', 'I', 'R', ':', 'O',
                                'S', 'E', 'r', 'r', 'o', 'r' };
static mwArray _mxarray44_ = mclInitializeString(20, _array45_);

static mxChar _array47_[2] = { '%', 's' };
static mwArray _mxarray46_ = mclInitializeString(2, _array47_);

static mxChar _array49_[9] = { 'd', 'e', 'l', 'i', 'm', 'i', 't', 'e', 'r' };
static mwArray _mxarray48_ = mclInitializeString(9, _array49_);

static mxChar _array51_[2] = { 0x005c, 'n' };
static mwArray _mxarray50_ = mclInitializeString(2, _array51_);

static mxChar _array53_[3] = { 'v', 'e', 'r' };
static mwArray _mxarray52_ = mclInitializeString(3, _array53_);

static mxChar _array55_[10] = { 'W', 'i', 'n', 'd', 'o',
                                'w', 's', ' ', '9', '5' };
static mwArray _mxarray54_ = mclInitializeString(10, _array55_);

static mxChar _array57_[10] = { 'W', 'i', 'n', 'd', 'o',
                                'w', 's', ' ', '9', '8' };
static mwArray _mxarray56_ = mclInitializeString(10, _array57_);

static mxChar _array59_[18] = { 'W', 'i', 'n', 'd', 'o', 'w', 's', ' ', 'M',
                                'i', 'l', 'l', 'e', 'n', 'n', 'i', 'u', 'm' };
static mwArray _mxarray58_ = mclInitializeString(18, _array59_);

static mxChar _array61_[6] = { 'm', 'k', 'd', 'i', 'r', ' ' };
static mwArray _mxarray60_ = mclInitializeString(6, _array61_);

static mxChar _array63_[2] = { '"', '~' };
static mwArray _mxarray62_ = mclInitializeString(2, _array63_);

static mxChar _array65_[2] = { '/', '"' };
static mwArray _mxarray64_ = mclInitializeString(2, _array65_);

void InitializeModule_mkdir() {
}

void TerminateModule_mkdir() {
}

static mwArray mkdir_ConsolidateMkdirStatus(mwArray Status = mwArray::DIN,
                                            mwArray OSMessage = mwArray::DIN);
#ifdef __cplusplus
extern "C"
#endif
void mlxMkdir_ConsolidateMkdirStatus(int nlhs,
                                     mxArray * plhs[],
                                     int nrhs,
                                     mxArray * prhs[]);
static mwArray mkdir_setwinmkdir();
#ifdef __cplusplus
extern "C"
#endif
void mlxMkdir_setwinmkdir(int nlhs,
                          mxArray * plhs[],
                          int nrhs,
                          mxArray * prhs[]);
static mwArray mkdir_winmkdir(mwArray * OSMessage,
                              mwArray Directory = mwArray::DIN,
                              mwArray WinSwitches = mwArray::DIN);
#ifdef __cplusplus
extern "C"
#endif
void mlxMkdir_winmkdir(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);
static mwArray mkdir_validpath(mwArray DirName = mwArray::DIN,
                               mwArray NewDirName = mwArray::DIN);
#ifdef __cplusplus
extern "C"
#endif
void mlxMkdir_validpath(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);
static mwArray Mmkdir(int nargout_, mwArray varargin);
static mwArray Mmkdir_ConsolidateMkdirStatus(int nargout_,
                                             mwArray Status,
                                             mwArray OSMessage);
static mwArray Mmkdir_setwinmkdir(int nargout_);
static mwArray Mmkdir_winmkdir(mwArray * OSMessage,
                               int nargout_,
                               mwArray Directory,
                               mwArray WinSwitches);
static mwArray Mmkdir_validpath(int nargout_,
                                mwArray DirName,
                                mwArray NewDirName);

static mexFunctionTableEntry local_function_table_[4]
  = { { "ConsolidateMkdirStatus",
        mlxMkdir_ConsolidateMkdirStatus, 2, 1, NULL },
      { "setwinmkdir", mlxMkdir_setwinmkdir, 0, 1, NULL },
      { "winmkdir", mlxMkdir_winmkdir, 2, 2, NULL },
      { "validpath", mlxMkdir_validpath, 2, 1, NULL } };

_mexLocalFunctionTable _local_function_table_mkdir
  = { 4, local_function_table_ };

//
// The function "Nmkdir" contains the nargout interface for the "mkdir"
// M-function from file "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines
// 1-201). This interface is only produced if the M-function uses the special
// variable "nargout". The nargout interface allows the number of requested
// outputs to be specified via the nargout argument, as opposed to the normal
// interface which dynamically calculates the number of outputs based on the
// number of non-NULL inputs it receives. This function processes any input
// arguments and passes them to the implementation version of the function,
// appearing above.
//
mwArray Nmkdir(int nargout, mwVarargout varargout, mwVarargin varargin) {
    nargout += varargout.Nargout();
    varargout.GetCell() = Mmkdir(nargout, varargin.ToArray());
    return varargout.AssignOutputs();
}

//
// The function "mkdir" contains the normal interface for the "mkdir"
// M-function from file "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines
// 1-201). This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
mwArray mkdir(mwVarargout varargout, mwVarargin varargin) {
    int nargout = 0;
    nargout += varargout.Nargout();
    varargout.GetCell() = Mmkdir(nargout, varargin.ToArray());
    return varargout.AssignOutputs();
}

//
// The function "Vmkdir" contains the void interface for the "mkdir" M-function
// from file "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 1-201). The
// void interface is only produced if the M-function uses the special variable
// "nargout", and has at least one output. The void interface function
// specifies zero output arguments to the implementation version of the
// function, and in the event that the implementation version still returns an
// output (which, in MATLAB, would be assigned to the "ans" variable), it
// deallocates the output. This function processes any input arguments and
// passes them to the implementation version of the function, appearing above.
//
void Vmkdir(mwVarargin varargin) {
    mwArray varargout = mwArray::UNDEFINED;
    varargout = Mmkdir(0, varargin.ToArray());
}

//
// The function "mlxMkdir" contains the feval interface for the "mkdir"
// M-function from file "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines
// 1-201). The feval function calls the implementation version of mkdir through
// this function. This function processes any input arguments and passes them
// to the implementation version of the function, appearing above.
//
void mlxMkdir(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[1];
        mwArray mplhs[1];
        mclCppUndefineArrays(1, mplhs);
        mprhs[0] = mclCreateVararginCell(nrhs, prhs);
        mplhs[0] = Mmkdir(nlhs, mprhs[0]);
        mclAssignVarargoutCell(0, nlhs, plhs, mplhs[0].FreezeData());
    }
    MW_END_MLX();
}

//
// The function "mkdir_ConsolidateMkdirStatus" contains the normal interface
// for the "mkdir/ConsolidateMkdirStatus" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 201-226). This function
// processes any input arguments and passes them to the implementation version
// of the function, appearing above.
//
static mwArray mkdir_ConsolidateMkdirStatus(mwArray Status, mwArray OSMessage) {
    int nargout = 1;
    mwArray Success = mwArray::UNDEFINED;
    Success = Mmkdir_ConsolidateMkdirStatus(nargout, Status, OSMessage);
    return Success;
}

//
// The function "mlxMkdir_ConsolidateMkdirStatus" contains the feval interface
// for the "mkdir/ConsolidateMkdirStatus" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 201-226). The feval
// function calls the implementation version of mkdir/ConsolidateMkdirStatus
// through this function. This function processes any input arguments and
// passes them to the implementation version of the function, appearing above.
//
void mlxMkdir_ConsolidateMkdirStatus(int nlhs,
                                     mxArray * plhs[],
                                     int nrhs,
                                     mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[2];
        mwArray mplhs[1];
        int i;
        mclCppUndefineArrays(1, mplhs);
        if (nlhs > 1) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: mkdir/ConsolidateMkdirSt"
                  "atus Line: 201 Column: 1 The function \"mkdir/"
                  "ConsolidateMkdirStatus\" was called with more "
                  "than the declared number of outputs (1).")));
        }
        if (nrhs > 2) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: mkdir/ConsolidateMkdirSt"
                  "atus Line: 201 Column: 1 The function \"mkdir/"
                  "ConsolidateMkdirStatus\" was called with more "
                  "than the declared number of inputs (2).")));
        }
        for (i = 0; i < 2 && i < nrhs; ++i) {
            mprhs[i] = mwArray(prhs[i], 0);
        }
        for (; i < 2; ++i) {
            mprhs[i].MakeDIN();
        }
        mplhs[0] = Mmkdir_ConsolidateMkdirStatus(nlhs, mprhs[0], mprhs[1]);
        plhs[0] = mplhs[0].FreezeData();
    }
    MW_END_MLX();
}

//
// The function "mkdir_setwinmkdir" contains the normal interface for the
// "mkdir/setwinmkdir" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 226-251). This function
// processes any input arguments and passes them to the implementation version
// of the function, appearing above.
//
static mwArray mkdir_setwinmkdir() {
    int nargout = 1;
    mwArray WinMkdirSwitches = mwArray::UNDEFINED;
    WinMkdirSwitches = Mmkdir_setwinmkdir(nargout);
    return WinMkdirSwitches;
}

//
// The function "mlxMkdir_setwinmkdir" contains the feval interface for the
// "mkdir/setwinmkdir" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 226-251). The feval
// function calls the implementation version of mkdir/setwinmkdir through this
// function. This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
void mlxMkdir_setwinmkdir(int nlhs,
                          mxArray * plhs[],
                          int nrhs,
                          mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mplhs[1];
        mclCppUndefineArrays(1, mplhs);
        if (nlhs > 1) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: mkdir/setwinmkdir Line: 226 Colu"
                  "mn: 1 The function \"mkdir/setwinmkdir\" was called wi"
                  "th more than the declared number of outputs (1).")));
        }
        if (nrhs > 0) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: mkdir/setwinmkdir Line: 226 Col"
                  "umn: 1 The function \"mkdir/setwinmkdir\" was called "
                  "with more than the declared number of inputs (0).")));
        }
        mplhs[0] = Mmkdir_setwinmkdir(nlhs);
        plhs[0] = mplhs[0].FreezeData();
    }
    MW_END_MLX();
}

//
// The function "mkdir_winmkdir" contains the normal interface for the
// "mkdir/winmkdir" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 251-290). This function
// processes any input arguments and passes them to the implementation version
// of the function, appearing above.
//
static mwArray mkdir_winmkdir(mwArray * OSMessage,
                              mwArray Directory,
                              mwArray WinSwitches) {
    int nargout = 1;
    mwArray Status = mwArray::UNDEFINED;
    mwArray OSMessage__ = mwArray::UNDEFINED;
    if (OSMessage != NULL) {
        ++nargout;
    }
    Status = Mmkdir_winmkdir(&OSMessage__, nargout, Directory, WinSwitches);
    if (OSMessage != NULL) {
        *OSMessage = OSMessage__;
    }
    return Status;
}

//
// The function "mlxMkdir_winmkdir" contains the feval interface for the
// "mkdir/winmkdir" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 251-290). The feval
// function calls the implementation version of mkdir/winmkdir through this
// function. This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
void mlxMkdir_winmkdir(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[2];
        mwArray mplhs[2];
        int i;
        mclCppUndefineArrays(2, mplhs);
        if (nlhs > 2) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: mkdir/winmkdir Line: 251 Colum"
                  "n: 1 The function \"mkdir/winmkdir\" was called with"
                  " more than the declared number of outputs (2).")));
        }
        if (nrhs > 2) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: mkdir/winmkdir Line: 251 Colu"
                  "mn: 1 The function \"mkdir/winmkdir\" was called wi"
                  "th more than the declared number of inputs (2).")));
        }
        for (i = 0; i < 2 && i < nrhs; ++i) {
            mprhs[i] = mwArray(prhs[i], 0);
        }
        for (; i < 2; ++i) {
            mprhs[i].MakeDIN();
        }
        mplhs[0] = Mmkdir_winmkdir(&mplhs[1], nlhs, mprhs[0], mprhs[1]);
        plhs[0] = mplhs[0].FreezeData();
        for (i = 1; i < 2 && i < nlhs; ++i) {
            plhs[i] = mplhs[i].FreezeData();
        }
    }
    MW_END_MLX();
}

//
// The function "mkdir_validpath" contains the normal interface for the
// "mkdir/validpath" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 290-309). This function
// processes any input arguments and passes them to the implementation version
// of the function, appearing above.
//
static mwArray mkdir_validpath(mwArray DirName, mwArray NewDirName) {
    int nargout = 1;
    mwArray Directory = mwArray::UNDEFINED;
    Directory = Mmkdir_validpath(nargout, DirName, NewDirName);
    return Directory;
}

//
// The function "mlxMkdir_validpath" contains the feval interface for the
// "mkdir/validpath" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 290-309). The feval
// function calls the implementation version of mkdir/validpath through this
// function. This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
void mlxMkdir_validpath(int nlhs,
                        mxArray * plhs[],
                        int nrhs,
                        mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[2];
        mwArray mplhs[1];
        int i;
        mclCppUndefineArrays(1, mplhs);
        if (nlhs > 1) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: mkdir/validpath Line: 290 Colu"
                  "mn: 1 The function \"mkdir/validpath\" was called wi"
                  "th more than the declared number of outputs (1).")));
        }
        if (nrhs > 2) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: mkdir/validpath Line: 290 Colu"
                  "mn: 1 The function \"mkdir/validpath\" was called wi"
                  "th more than the declared number of inputs (2).")));
        }
        for (i = 0; i < 2 && i < nrhs; ++i) {
            mprhs[i] = mwArray(prhs[i], 0);
        }
        for (; i < 2; ++i) {
            mprhs[i].MakeDIN();
        }
        mplhs[0] = Mmkdir_validpath(nlhs, mprhs[0], mprhs[1]);
        plhs[0] = mplhs[0].FreezeData();
    }
    MW_END_MLX();
}

//
// The function "Mmkdir" is the implementation version of the "mkdir"
// M-function from file "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines
// 1-201). It contains the actual compiled code for that M-function. It is a
// static function and must only be called from one of the interface functions,
// appearing below.
//
//
// function varargout=mkdir(varargin)
//
static mwArray Mmkdir(int nargout_, mwArray varargin) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_mkdir;
    int nargin_ = nargin(-1, mwVarargin(varargin));
    mwArray varargout = mwArray::UNDEFINED;
    mwArray WinSwitches = mwArray::UNDEFINED;
    mwArray WarningID = mwArray::UNDEFINED;
    mwArray WarningMessage = mwArray::UNDEFINED;
    mwArray Directory = mwArray::UNDEFINED;
    mwArray NewDirName = mwArray::UNDEFINED;
    mwArray DirName = mwArray::UNDEFINED;
    mwArray PreWin2000 = mwArray::UNDEFINED;
    mwArray OSMessage = mwArray::UNDEFINED;
    mwArray Status = mwArray::UNDEFINED;
    mwArray ErrorID = mwArray::UNDEFINED;
    mwArray ErrorMessage = mwArray::UNDEFINED;
    mwArray OldDir = mwArray::UNDEFINED;
    mwArray Success = mwArray::UNDEFINED;
    mwArray ArgOutError = mwArray::UNDEFINED;
    mwArray ans = mwArray::UNDEFINED;
    mwArray ArgError = mwArray::UNDEFINED;
    //
    // %MKDIR   Make new directory.
    // %   [SUCCESS,MESSAGE,MESSAGEID] = MKDIR(PARENTDIR,NEWDIR) makes a new directory,
    // %   NEWDIR, under the parent, PARENTDIR. While PARENTDIR may be an absolute
    // %   path, NEWDIR must be a relative path. When NEWDIR exists, MKDIR returns
    // %   SUCCESS = 1 and issues to the user a warning that the directory already
    // %   exists.
    // %
    // %   [SUCCESS,MESSAGE,MESSAGEID] = MKDIR(NEWDIR) creates the directory NEWDIR
    // %   in the current directory. 
    // %
    // %   [SUCCESS,MESSAGE,MESSAGEID] = MKDIR(PARENTDIR,NEWDIR) creates the
    // %   directory NEWDIR in the existing directory PARENTDIR. 
    // %
    // %   INPUT PARAMETERS:
    // %       PARENTDIR : string specifying the parent directory. See NOTE 1.
    // %       NEWDIR : string specifying the new directory. 
    // %
    // %   RETURN PARAMETERS:
    // %       SUCCESS: logical scalar, defining the outcome of MKDIR. 
    // %                1 : MKDIR executed successfully.
    // %                0 : an error occurred.
    // %       MESSAGE: string, defining the error or warning message. 
    // %                empty string : MKDIR executed successfully.
    // %                message : an error or warning message, as applicable.
    // %       MESSAGEID: string, defining the error or warning identifier.
    // %                  empty string : MKDIR executed successfully.
    // %                  message id: the MATLAB error or warning message identifier
    // %                  (see ERROR, LASTERR, WARNING, LASTWARN).
    // %
    // %   NOTE 1: UNC paths are supported. 
    // %
    // %   See also CD, COPYFILE, DELETE, DIR, FILEATTRIB, MOVEFILE, RMDIR.
    // 
    // %   JP Barnard
    // %   Copyright 1984-2002 The MathWorks, Inc. 
    // %   $Revision: 1.37 $ $Date: 2002/06/06 18:42:43 $
    // % -----------------------------------------------------------------------------
    // 
    // % Set up MKDIR
    // 
    // % test if source and destination arguments are strings
    // % handle input arguments
    // ArgError = nargchk(1,2,nargin);  % Number of input arguments must be 1 of 2.
    //
    ArgError = nargchk(_mxarray0_, _mxarray1_, nargin_);
    //
    // if ~isempty(ArgError)
    //
    if (mclNotBool(isempty(mwVv(ArgError, "ArgError")))) {
        //
        // error('MATLAB:MKDIR:NumberOfInputArguments',ArgError);
        //
        error(mwVarargin(_mxarray2_, mwVv(ArgError, "ArgError")));
    //
    // end
    //
    }
    //
    // 
    // % check if additional arguments are strings
    // if ~isempty(varargin) & ~iscellstr(varargin) 
    //
    {
        mwArray a_ = ~ isempty(mwVa(varargin, "varargin"));
        if (tobool(a_)
            && tobool(a_ & ~ iscellstr(mwVa(varargin, "varargin")))) {
            //
            // error('MATLAB:MKDIR:ArgumentType','Arguments must be strings')
            //
            error(mwVarargin(_mxarray4_, _mxarray6_));
        } else {
        }
    //
    // end
    //
    }
    //
    // 
    // % handle output arguments
    // % Number of output arguments must be 1 to 3.
    // ArgOutError = nargoutchk(-1,3,nargout);  
    //
    ArgOutError = nargoutchk(_mxarray8_, _mxarray9_, nargout_);
    //
    // if ~isempty(ArgOutError)
    //
    if (mclNotBool(isempty(mwVv(ArgOutError, "ArgOutError")))) {
        //
        // error('MATLAB:MKDIR:NumberOfOutputArguments',ArgOutError);
        //
        error(mwVarargin(_mxarray10_, mwVv(ArgOutError, "ArgOutError")));
    //
    // end
    //
    }
    //
    // 
    // % Initialise variables.
    // Success = true;
    //
    Success = true_func(mwVarargin());
    //
    // OldDir = '';
    //
    OldDir = _mxarray12_;
    //
    // ErrorMessage='';  % annotations to raw OS error message
    //
    ErrorMessage = _mxarray12_;
    //
    // ErrorID = '';
    //
    ErrorID = _mxarray12_;
    //
    // Status = 0;
    //
    Status = _mxarray13_;
    //
    // OSMessage = '';   % raw OS message
    //
    OSMessage = _mxarray12_;
    //
    // PreWin2000 = false;
    //
    PreWin2000 = false_func(mwVarargin());
    //
    // 
    // % handle input arguments
    // if nargin == 1
    //
    if (nargin_ == 1) {
        //
        // % Mode 1: create a new directory inside current directory
        // DirName = pwd;
        //
        DirName = pwd();
        //
        // NewDirName = varargin{1};
        //
        NewDirName = mwVa(varargin, "varargin").cell(_mxarray0_);
    //
    // 
    // elseif nargin == 2
    //
    } else if (nargin_ == 2) {
        //
        // % Mode 2: create a new directory inside a specified directory
        // if ~isempty(varargin{2})
        //
        if (mclNotBool(
              feval(
                mwValueVarargout(),
                mlxIsempty,
                mwVarargin(mwVa(varargin, "varargin").cell(_mxarray1_))))) {
            //
            // DirName = varargin{1};
            //
            DirName = mwVa(varargin, "varargin").cell(_mxarray0_);
            //
            // NewDirName = varargin{2};
            //
            NewDirName = mwVa(varargin, "varargin").cell(_mxarray1_);
        //
        // else
        //
        } else {
            //
            // error('MATLAB:MKDIR:ArgumentIndeterminate',...
            //
            error(mwVarargin(_mxarray14_, _mxarray16_));
        //
        // 'Second directory argument is an empty string.');
        // end
        //
        }
    //
    // end
    //
    }
    //
    // 
    // 
    // % Build full path that has valid path syntax.
    // % Add double quotes around the source and destination files 
    // %	so as to support file names containing spaces.
    // Directory = validpath(DirName,NewDirName);
    //
    Directory
      = mkdir_validpath(
          mwVv(DirName, "DirName"), mwVv(NewDirName, "NewDirName"));
    //
    // 
    // % rehash non-toolbox directory path global
    // rehash path
    //
    ans.EqPrintAns(rehash(_mxarray18_));
    //
    // % -----------------------------------------------------------------------------
    // % Attempt to make directory
    // 
    // try
    //
    try {
        //
        // % Throw error if UNC path is found in new directory name
        // if strncmp('\\',NewDirName,2)
        //
        if (tobool(
              strncmp(
                _mxarray20_, mwVv(NewDirName, "NewDirName"), _mxarray1_))) {
            //
            // error('MATLAB:MKDIR:DirectoryIsUNC',...
            //
            error(
              mwVarargin(_mxarray22_, _mxarray24_, mwVv(DirName, "DirName")));
        //
        // 'Cannot create UNC directory inside %s',DirName);
        // end
        //
        }
        //
        // 
        // % Throw error if new directory name implies an absolute path.
        // if ~isempty(strfind(NewDirName,':'))
        //
        if (mclNotBool(
              isempty(strfind(mwVv(NewDirName, "NewDirName"), _mxarray26_)))) {
            //
            // error('MATLAB:MKDIR:DirectoryContainsDriveLetter',...
            //
            error(
              mwVarargin(_mxarray28_, _mxarray30_, mwVv(DirName, "DirName")));
        //
        // 'Cannot create absolute directory inside %s',DirName);
        // end
        //
        }
        //
        // 
        // % Test for existance of directory
        // if ~isempty(dir(strrep(Directory,'"','')))
        //
        if (mclNotBool(
              isempty(
                Ndir(
                  1,
                  strrep(
                    mwVv(Directory, "Directory"),
                    _mxarray32_,
                    _mxarray12_))))) {
            //
            // WarningMessage = sprintf('Directory "%s" already exists.', NewDirName);
            //
            WarningMessage
              = sprintf(
                  _mxarray34_, mwVarargin(mwVv(NewDirName, "NewDirName")));
            //
            // WarningID = 'MATLAB:MKDIR:DirectoryExists';
            //
            WarningID = _mxarray36_;
            //
            // 
            // if nargout
            //
            if (nargout_ != 0) {
                //
                // varargout{1} = Success;
                //
                varargout.cell(_mxarray0_) = mwVv(Success, "Success");
                //
                // varargout{2} = WarningMessage;
                //
                varargout.cell(_mxarray1_)
                = mwVv(WarningMessage, "WarningMessage");
                //
                // varargout{3} = WarningID;
                //
                varargout.cell(_mxarray9_) = mwVv(WarningID, "WarningID");
            //
            // else
            //
            } else {
                //
                // warning(WarningID, WarningMessage, NewDirName);
                //
                ans.EqAns(
                  Nwarning(
                    0,
                    NULL,
                    mwVarargin(
                      mwVv(WarningID, "WarningID"),
                      mwVv(WarningMessage, "WarningMessage"),
                      mwVv(NewDirName, "NewDirName"))));
            //
            // end
            //
            }
            //
            // return
            //
            goto return_;
        //
        // end
        //
        }
        //
        // 
        // % UNIX file system
        // 
        // if isunix
        //
        if (tobool(isunix())) {
            //
            // % ensure correct file separator
            // Directory = strrep(Directory,'\',filesep);
            //
            Directory
              = strrep(mwVv(Directory, "Directory"), _mxarray38_, filesep());
            //
            // 
            // % make directory structure
            // [Status, OSMessage] = unix(['mkdir -p ' Directory]); 
            //
            Status
            = unix_func(
                &OSMessage,
                horzcat(
                  mwVarargin(_mxarray40_, mwVv(Directory, "Directory"))));
        //
        // 
        // % MS DOS file system
        // 
        // elseif ispc
        //
        } else if (tobool(ispc())) {
            //
            // 
            // % Change to safe directory in Windows when UNC path cause failures
            // OldDir = cdsafewindir; % store current directory
            //
            OldDir = general_private_cdsafewindir();
            //
            // 
            // % find version of Windows
            // WinSwitches = setwinmkdir;
            //
            WinSwitches = mkdir_setwinmkdir();
            //
            // 
            // % ensure correct file separator
            // Directory = strrep(Directory,'/',filesep);
            //
            Directory
              = strrep(mwVv(Directory, "Directory"), _mxarray42_, filesep());
            //
            // 
            // % make directory
            // [Status,OSMessage]=winmkdir(Directory,WinSwitches);
            //
            Status
            = mkdir_winmkdir(
                &OSMessage,
                mwVv(Directory, "Directory"),
                mwVv(WinSwitches, "WinSwitches"));
            //
            // 
            // % if changed to %windir%, restore original current directory
            // if ~isempty(OldDir)
            //
            if (mclNotBool(isempty(mwVv(OldDir, "OldDir")))) {
                //
                // cd(OldDir);
                //
                ans.EqAns(Ncd(0, mwVv(OldDir, "OldDir")));
            //
            // end
            //
            }
        //
        // 
        // end % if computer type
        //
        }
        //
        // 
        // %---------------------------------------------------------------------------   
        // % Consolidate OS status reply. 
        // % We consistently return Success = false if anything on error or warning. 
        // Success = ConsolidateMkdirStatus(Status,OSMessage);      
        //
        Success
          = mkdir_ConsolidateMkdirStatus(
              mwVv(Status, "Status"), mwVv(OSMessage, "OSMessage"));
        //
        // 
        // % throw applicable OS errors.
        // if ~Success
        //
        if (mclNotBool(mwVv(Success, "Success"))) {
            //
            // error('MATLAB:MKDIR:OSError','%s',strvcat(OSMessage,ErrorMessage)') 
            //
            error(
              mwVarargin(
                _mxarray44_,
                _mxarray46_,
                ctranspose(
                  strvcat(
                    mwVarargin(
                      mwVv(OSMessage, "OSMessage"),
                      mwVv(ErrorMessage, "ErrorMessage"))))));
        //
        // end
        //
        }
    //
    // 
    // catch
    //
    } catch(mwException e_) {
        //
        // Success = false;
        //
        Success = false_func(mwVarargin());
        //
        // [ErrorMessage,ErrorID] = lasterr;
        //
        ErrorMessage = lasterr(&ErrorID, mwArray::DIN);
        //
        // % extract descriptive lines from error message
        // if ~isempty(ErrorMessage)
        //
        if (mclNotBool(isempty(mwVv(ErrorMessage, "ErrorMessage")))) {
            //
            // ErrorMessage = strread(ErrorMessage,'%s','delimiter','\n');
            //
            ErrorMessage
              = Nstrread(
                  0,
                  mwValueVarargout(),
                  mwVarargin(
                    mwVv(ErrorMessage, "ErrorMessage"),
                    _mxarray46_,
                    _mxarray48_,
                    _mxarray50_));
            //
            // ErrorMessage = strvcat(ErrorMessage(2:end));
            //
            ErrorMessage
              = strvcat(
                  mwVarargin(
                    mclArrayRef(
                      mwVv(ErrorMessage, "ErrorMessage"),
                      colon(
                        _mxarray1_,
                        end(
                          mwVv(ErrorMessage, "ErrorMessage"),
                          _mxarray0_,
                          _mxarray0_)))));
        //
        // end
        //
        }
        //
        // % throw error if no output arguments are specified
        // if ~nargout 
        //
        if (svDoubleScalarEq((double) nargout_, 0.0)) {
            //
            // error(ErrorID,'%s',ErrorMessage');
            //
            error(
              mwVarargin(
                mwVv(ErrorID, "ErrorID"),
                _mxarray46_,
                ctranspose(mwVv(ErrorMessage, "ErrorMessage"))));
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
    // %------------------------------------------------------------------------------
    // % parse output values to output parameters, if outout arguments are specified
    // if nargout
    //
    if (nargout_ != 0) {
        //
        // varargout{1} = Success;
        //
        varargout.cell(_mxarray0_) = mwVv(Success, "Success");
        //
        // varargout{2} = ErrorMessage;
        //
        varargout.cell(_mxarray1_) = mwVv(ErrorMessage, "ErrorMessage");
        //
        // varargout{3} = ErrorID;
        //
        varargout.cell(_mxarray9_) = mwVv(ErrorID, "ErrorID");
    //
    // end
    //
    }
    //
    // %==============================================================================
    // % end of MKDIR
    // 
    // 
    // % ConsolidateMkdirStatus. Consolidate the status returns in COPYFILE into a
    // %     success logical output
    // % Input:
    // %        Status: scalar double defining the status output from OS calls
    // %        OSMessage: string array defining OS call message outputs
    // % Return:
    // %        Success: logical scalar defining outcome of COPYFILE
    // %------------------------------------------------------------------------------
    //
    return_:
    return varargout;
}

//
// The function "Mmkdir_ConsolidateMkdirStatus" is the implementation version
// of the "mkdir/ConsolidateMkdirStatus" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 201-226). It contains
// the actual compiled code for that M-function. It is a static function and
// must only be called from one of the interface functions, appearing below.
//
//
// function [Success] = ConsolidateMkdirStatus(Status,OSMessage)
//
static mwArray Mmkdir_ConsolidateMkdirStatus(int nargout_,
                                             mwArray Status,
                                             mwArray OSMessage) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_mkdir;
    mwArray Success = mwArray::UNDEFINED;
    //
    // %------------------------------------------------------------------------------
    // switch Status
    //
    mwArray v_ = mwVa(Status, "Status");
    if (switchcompare(v_, _mxarray13_)) {
        //
        // 
        // case 0
        // if isempty(OSMessage)
        //
        if (tobool(isempty(mwVa(OSMessage, "OSMessage")))) {
            //
            // Success = true; % no error
            //
            Success = true_func(mwVarargin());
        //
        // else
        //
        } else {
            //
            // % an error with zero status value occurred (originates from WIN95/98/ME)
            // Success = false; 
            //
            Success = false_func(mwVarargin());
        //
        // end
        //
        }
    //
    // 
    // otherwise
    //
    } else {
        //
        // Success = false; % some error or warning was returned by the OS call
        //
        Success = false_func(mwVarargin());
    //
    // end
    //
    }
    mwValidateOutput(
      Success, 1, nargout_, "Success", "mkdir/ConsolidateMkdirStatus");
    return Success;
    //
    // %------------------------------------------------------------------------------
    // return
    // % end of ConsolidateMkdirStatus
    // %==============================================================================
    // 
    // % SETWINMKDIR. determine Windows platform
    // % Return:
    // %        WinCopySwitches: struct scalar defining copy and xcopy switches
    // %           .PreWin2000: logical scalar defining pre or post Windows 2000 (0 or 1)
    // %------------------------------------------------------------------------------
    //
}

//
// The function "Mmkdir_setwinmkdir" is the implementation version of the
// "mkdir/setwinmkdir" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 226-251). It contains
// the actual compiled code for that M-function. It is a static function and
// must only be called from one of the interface functions, appearing below.
//
//
// function [WinMkdirSwitches]=setwinmkdir
//
static mwArray Mmkdir_setwinmkdir(int nargout_) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_mkdir;
    mwArray WinMkdirSwitches = mwArray::UNDEFINED;
    mwArray WinVersion = mwArray::UNDEFINED;
    mwArray Status = mwArray::UNDEFINED;
    //
    // %------------------------------------------------------------------------------
    // % find version of Windows
    // [Status,WinVersion] = dos('ver');
    //
    Status = dos(&WinVersion, _mxarray52_);
    //
    // if length(strfind(WinVersion,'Windows 95')) || ...
    //
    if (mclLengthInt(strfind(mwVv(WinVersion, "WinVersion"), _mxarray54_)) != 0
        || mclLengthInt(strfind(mwVv(WinVersion, "WinVersion"), _mxarray56_))
           != 0
        || mclLengthInt(strfind(mwVv(WinVersion, "WinVersion"), _mxarray58_))
           != 0) {
        //
        // length(strfind(WinVersion,'Windows 98')) || ...
        // length(strfind(WinVersion,'Windows Millennium'))
        // WinMkdirSwitches.PreWin2000 = true;
        //
        WinMkdirSwitches.field("PreWin2000") = true_func(mwVarargin());
    //
    // else
    //
    } else {
        //
        // WinMkdirSwitches.PreWin2000 = false;
        //
        WinMkdirSwitches.field("PreWin2000") = false_func(mwVarargin());
    //
    // end
    //
    }
    mwValidateOutput(
      WinMkdirSwitches, 1, nargout_, "WinMkdirSwitches", "mkdir/setwinmkdir");
    return WinMkdirSwitches;
    //
    // %-------------------------------------------------------------------------------
    // return
    // %===============================================================================
    // 
    // % WINMKDIR. makes directory on various Windows platforms
    // % 
    // % Input:
    // %        Directory: string defining directory path
    // %        WinSwitches: struct defining Windows specific switches
    // %           .PreWin2000: logical scalar defining pre or post Windows 2000 (0 or 1)
    // % Return:
    // %        Status: OS command status
    // %        OSMessage: string containing OS message, if any.
    // %------------------------------------------------------------------------------
    //
}

//
// The function "Mmkdir_winmkdir" is the implementation version of the
// "mkdir/winmkdir" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 251-290). It contains
// the actual compiled code for that M-function. It is a static function and
// must only be called from one of the interface functions, appearing below.
//
//
// function [Status,OSMessage]=winmkdir(Directory,WinSwitches)
//
static mwArray Mmkdir_winmkdir(mwArray * OSMessage,
                               int nargout_,
                               mwArray Directory,
                               mwArray WinSwitches) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_mkdir;
    mwArray Status = mwArray::UNDEFINED;
    mwArray i = mwArray::UNDEFINED;
    mwArray _T1_ = mwArray::UNDEFINED;
    mwArray ext = mwArray::UNDEFINED;
    mwArray _T0_ = mwArray::UNDEFINED;
    mwArray subtree = mwArray::UNDEFINED;
    mwArray nrlevels = mwArray::UNDEFINED;
    mwArray parentDir = mwArray::UNDEFINED;
    //
    // %------------------------------------------------------------------------------
    // if WinSwitches.PreWin2000
    //
    if (tobool(mwVa(WinSwitches, "WinSwitches").field("PreWin2000"))) {
        //
        // % Pre Windows 2000 we need to make a subtree iteratively, since DOS MKDIR
        // % cannot make a subdirectory tree at once. 
        // 
        // % Temporarily strip double quotes.
        // parentDir = strrep(Directory,'"',''); 
        //
        parentDir
          = strrep(mwVa(Directory, "Directory"), _mxarray32_, _mxarray12_);
        //
        // % count subdirectory tree levels up from bottom of directory tree.
        // nrlevels = 0; 
        //
        nrlevels = _mxarray13_;
        //
        // 
        // % Find path depth at which directory tree exists.
        // while isempty(dir(parentDir))
        //
        while (tobool(isempty(Ndir(1, mwVv(parentDir, "parentDir"))))) {
            //
            // nrlevels = nrlevels+1;
            //
            nrlevels = mwVv(nrlevels, "nrlevels") + _mxarray0_;
            _T0_ = mwVv(nrlevels, "nrlevels");
            _T1_ = mwVv(nrlevels, "nrlevels");
            //
            // [parentDir,subtree{nrlevels},ext{nrlevels}] = fileparts(parentDir);
            //
            feval(
              mwVarargout(parentDir, subtree.cell(_T0_), ext.cell(_T1_)),
              mlxFileparts,
              mwVarargin(mwVv(parentDir, "parentDir")));
        //
        // end
        //
        }
        //
        // 
        // % Build subdirectory tree recursively.
        // for i  = nrlevels:-1:1
        //
        {
            mwForLoopIterator viter__;
            for (viter__.Start(
                   mwVv(nrlevels, "nrlevels"), _mxarray8_, _mxarray0_);
                 viter__.Next(&i);
                 ) {
                //
                // parentDir = validpath(parentDir,[subtree{i},ext{nrlevels}]);
                //
                parentDir
                  = mkdir_validpath(
                      mwVv(parentDir, "parentDir"),
                      horzcat(
                        mwVarargin(
                          mwVv(subtree, "subtree").cell(mwVv(i, "i")),
                          mwVv(ext, "ext").cell(mwVv(nrlevels, "nrlevels")))));
                //
                // [Status, OSMessage] = dos(['mkdir ', parentDir]);
                //
                Status
                = dos(
                    OSMessage,
                    horzcat(
                      mwVarargin(_mxarray60_, mwVv(parentDir, "parentDir"))));
            //
            // end
            //
            }
        }
    //
    // 
    // else
    //
    } else {
        //
        // % make new directory
        // [Status, OSMessage] = dos(['mkdir ' Directory]);
        //
        Status
        = dos(
            OSMessage,
            horzcat(mwVarargin(_mxarray60_, mwVa(Directory, "Directory"))));
    //
    // end
    //
    }
    mwValidateOutput(Status, 1, nargout_, "Status", "mkdir/winmkdir");
    mwValidateOutput(*OSMessage, 2, nargout_, "OSMessage", "mkdir/winmkdir");
    return Status;
    //
    // %-------------------------------------------------------------------------------
    // return
    // %===============================================================================
    // 
    // % VALIDPATH. makes directory on various Windows platforms
    // % 
    // % Input:
    // %        DirName: string defining parent directory
    // %        NewDirName: string defining new directory
    // % Return:
    // %        Directory: string defining full path to new directory
    // %------------------------------------------------------------------------------
    //
}

//
// The function "Mmkdir_validpath" is the implementation version of the
// "mkdir/validpath" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\mkdir.m" (lines 290-309). It contains
// the actual compiled code for that M-function. It is a static function and
// must only be called from one of the interface functions, appearing below.
//
//
// function [Directory] = validpath(DirName,NewDirName)
//
static mwArray Mmkdir_validpath(int nargout_,
                                mwArray DirName,
                                mwArray NewDirName) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_mkdir;
    mwArray Directory = mwArray::UNDEFINED;
    mwArray remainder = mwArray::UNDEFINED;
    mwArray firstPathPart = mwArray::UNDEFINED;
    //
    // %------------------------------------------------------------------------------
    // % Add double quotes around the source and destination files 
    // %	so as to support file names containing spaces. 
    // 
    // Directory = ['"' fullfile(DirName,NewDirName) '"'];
    //
    Directory
      = horzcat(
          mwVarargin(
            _mxarray32_,
            fullfile(
              mwVarargin(
                mwVa(DirName, "DirName"), mwVa(NewDirName, "NewDirName"))),
            _mxarray32_));
    //
    // 
    // % place ~ outside quoted path, otherwise UNIX would not translate ~
    // if strcmp(Directory(1:2),'"~') 
    //
    if (tobool(
          strcmp(
            mclArrayRef(
              mwVv(Directory, "Directory"), colon(_mxarray0_, _mxarray1_)),
            _mxarray62_))) {
        //
        // if length(Directory)>4
        //
        if (mclLengthInt(mwVv(Directory, "Directory")) > 4) {
            //
            // [firstPathPart,remainder] = strtok(Directory,filesep);
            //
            firstPathPart
            = Nstrtok(2, &remainder, mwVv(Directory, "Directory"), filesep());
            //
            // Directory = [firstPathPart(2:end),'/"',remainder(2:end)];
            //
            Directory
              = horzcat(
                  mwVarargin(
                    mclArrayRef(
                      mwVv(firstPathPart, "firstPathPart"),
                      colon(
                        _mxarray1_,
                        end(
                          mwVv(firstPathPart, "firstPathPart"),
                          _mxarray0_,
                          _mxarray0_))),
                    _mxarray64_,
                    mclArrayRef(
                      mwVv(remainder, "remainder"),
                      colon(
                        _mxarray1_,
                        end(
                          mwVv(remainder, "remainder"),
                          _mxarray0_,
                          _mxarray0_)))));
        //
        // else
        //
        } else {
            //
            // Directory = DirName;
            //
            Directory = mwVa(DirName, "DirName");
        //
        // end
        //
        }
    //
    // end
    //
    }
    mwValidateOutput(Directory, 1, nargout_, "Directory", "mkdir/validpath");
    return Directory;
    //
    // %-------------------------------------------------------------------------------
    // return
    // %===============================================================================
    //
}
