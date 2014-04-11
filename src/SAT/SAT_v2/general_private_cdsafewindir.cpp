//
// MATLAB Compiler: 3.0
// Date: Wed Jul 14 15:58:49 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "test2" 
//
#include "general_private_cdsafewindir.hpp"
#include "libmatlbm.hpp"
#include "libmmfile.hpp"
static mwArray _mxarray0_ = mclInitializeCharVector(0, 0, (mxChar *)NULL);

static mxChar _array2_[2] = { 'c', 'd' };
static mwArray _mxarray1_ = mclInitializeString(2, _array2_);

static mxChar _array4_[6] = { 'w', 'i', 'n', 'd', 'i', 'r' };
static mwArray _mxarray3_ = mclInitializeString(6, _array4_);

void InitializeModule_general_private_cdsafewindir() {
}

void TerminateModule_general_private_cdsafewindir() {
}

static mwArray Mgeneral_private_cdsafewindir(int nargout_);

_mexLocalFunctionTable _local_function_table_general_private_cdsafewindir
  = { 0, (mexFunctionTableEntry *)NULL };

//
// The function "general_private_cdsafewindir" contains the normal interface
// for the "general/private/cdsafewindir" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\private\cdsafewindir.m" (lines 1-29).
// This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
mwArray general_private_cdsafewindir() {
    int nargout = 1;
    mwArray cwd = mwArray::UNDEFINED;
    cwd = Mgeneral_private_cdsafewindir(nargout);
    return cwd;
}

//
// The function "mlxGeneral_private_cdsafewindir" contains the feval interface
// for the "general/private/cdsafewindir" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\private\cdsafewindir.m" (lines 1-29).
// The feval function calls the implementation version of
// general/private/cdsafewindir through this function. This function processes
// any input arguments and passes them to the implementation version of the
// function, appearing above.
//
void mlxGeneral_private_cdsafewindir(int nlhs,
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
                  "Run-time Error: File: general/private/cdsafewi"
                  "ndir Line: 15 Column: 1 The function \"general"
                  "/private/cdsafewindir\" was called with more t"
                  "han the declared number of outputs (1).")));
        }
        if (nrhs > 0) {
            error(
              mwVarargin(
                mwArray(
                  "Run-time Error: File: general/private/cdsafewindir Line: 15 "
                  "Column: 1 The function \"general/private/cdsafewindir\" was "
                  "called with more than the declared number of inputs (0).")));
        }
        mplhs[0] = Mgeneral_private_cdsafewindir(nlhs);
        plhs[0] = mplhs[0].FreezeData();
    }
    MW_END_MLX();
}

//
// The function "Mgeneral_private_cdsafewindir" is the implementation version
// of the "general/private/cdsafewindir" M-function from file
// "c:\matlab6p5\toolbox\matlab\general\private\cdsafewindir.m" (lines 1-29).
// It contains the actual compiled code for that M-function. It is a static
// function and must only be called from one of the interface functions,
// appearing below.
//
//
// % CDSAFEWINDIR. Change to safe directory in Windows when UNC path cause failures
// % This is to check and see if the dos command is working.  In Win95
// % if the current directory is a deeply nested directory or sometimes
// % for TAS served file systems, the output pipe does not work.  The 
// % solution is to make the current directory safe, %windir% and restore
// % it afterwards.  The test is the cd command. 
// % [cwd] = cdsafewindir
// % Return:
// %        cwd: string defining path of current working directory
// 
// %  JP Barnard
// %  Copyright 1984-2002 The MathWorks, Inc.
// %  $Revision: 1.3 $ $Date: 2002/04/08 20:51:29 $
// %-------------------------------------------------------------------------------
// function [cwd] = cdsafewindir
//
static mwArray Mgeneral_private_cdsafewindir(int nargout_) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_general_private_cdsafewindir;
    mwArray cwd = mwArray::UNDEFINED;
    mwArray ans = mwArray::UNDEFINED;
    mwArray tmp = mwArray::UNDEFINED;
    //
    // %-------------------------------------------------------------------------------
    // cwd = '';
    //
    cwd = _mxarray0_;
    //
    // 
    // try % test for MS DOS related unsafe directories.
    //
    try {
        //
        // [tmp,tmp]=dos('cd'); % CD should return no message if in a safe directory.
        //
        tmp = dos(&tmp, _mxarray1_);
    //
    // catch % catch MS DOS file handling errors, related to unsafe directory
    //
    } catch(mwException e_) {
        //
        // cwd = pwd; % store current directory
        //
        cwd = pwd();
        //
        // cd(getenv('windir')); % change to safe directory (OS root directory)
        //
        ans.EqAns(Ncd(0, getenv(_mxarray3_)));
    //
    // end
    //
    }
    mwValidateOutput(cwd, 1, nargout_, "cwd", "general/private/cdsafewindir");
    return cwd;
    //
    // %-------------------------------------------------------------------------------
    // return
    // % end of CDSAFEWINDIR
    // %===============================================================================
    //
}
