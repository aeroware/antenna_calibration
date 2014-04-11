//
// MATLAB Compiler: 3.0
// Date: Wed Jul 14 15:58:49 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "test2" 
//
#include "strread.hpp"
#include "dataread_mex_interface.hpp"
#include "libmatlbm.hpp"
#include "libmmfile.hpp"
static mwArray _mxarray0_ = mclInitializeDouble(1.0);
static double _ieee_plusinf_ = mclGetInf();
static mwArray _mxarray1_ = mclInitializeDouble(_ieee_plusinf_);

static mxChar _array3_[6] = { 's', 't', 'r', 'i', 'n', 'g' };
static mwArray _mxarray2_ = mclInitializeString(6, _array3_);

void InitializeModule_strread() {
}

void TerminateModule_strread() {
}

static mwArray Mstrread(int nargout_, mwArray varargin);

_mexLocalFunctionTable _local_function_table_strread
  = { 0, (mexFunctionTableEntry *)NULL };

//
// The function "Nstrread" contains the nargout interface for the "strread"
// M-function from file "c:\matlab6p5\toolbox\matlab\iofun\strread.m" (lines
// 1-52). This interface is only produced if the M-function uses the special
// variable "nargout". The nargout interface allows the number of requested
// outputs to be specified via the nargout argument, as opposed to the normal
// interface which dynamically calculates the number of outputs based on the
// number of non-NULL inputs it receives. This function processes any input
// arguments and passes them to the implementation version of the function,
// appearing above.
//
mwArray Nstrread(int nargout, mwVarargout varargout, mwVarargin varargin) {
    nargout += varargout.Nargout();
    varargout.GetCell() = Mstrread(nargout, varargin.ToArray());
    return varargout.AssignOutputs();
}

//
// The function "strread" contains the normal interface for the "strread"
// M-function from file "c:\matlab6p5\toolbox\matlab\iofun\strread.m" (lines
// 1-52). This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
mwArray strread(mwVarargout varargout, mwVarargin varargin) {
    int nargout = 0;
    nargout += varargout.Nargout();
    varargout.GetCell() = Mstrread(nargout, varargin.ToArray());
    return varargout.AssignOutputs();
}

//
// The function "Vstrread" contains the void interface for the "strread"
// M-function from file "c:\matlab6p5\toolbox\matlab\iofun\strread.m" (lines
// 1-52). The void interface is only produced if the M-function uses the
// special variable "nargout", and has at least one output. The void interface
// function specifies zero output arguments to the implementation version of
// the function, and in the event that the implementation version still returns
// an output (which, in MATLAB, would be assigned to the "ans" variable), it
// deallocates the output. This function processes any input arguments and
// passes them to the implementation version of the function, appearing above.
//
void Vstrread(mwVarargin varargin) {
    mwArray varargout = mwArray::UNDEFINED;
    varargout = Mstrread(0, varargin.ToArray());
}

//
// The function "mlxStrread" contains the feval interface for the "strread"
// M-function from file "c:\matlab6p5\toolbox\matlab\iofun\strread.m" (lines
// 1-52). The feval function calls the implementation version of strread
// through this function. This function processes any input arguments and
// passes them to the implementation version of the function, appearing above.
//
void mlxStrread(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[1];
        mwArray mplhs[1];
        mclCppUndefineArrays(1, mplhs);
        mprhs[0] = mclCreateVararginCell(nrhs, prhs);
        mplhs[0] = Mstrread(nlhs, mprhs[0]);
        mclAssignVarargoutCell(0, nlhs, plhs, mplhs[0].FreezeData());
    }
    MW_END_MLX();
}

//
// The function "Mstrread" is the implementation version of the "strread"
// M-function from file "c:\matlab6p5\toolbox\matlab\iofun\strread.m" (lines
// 1-52). It contains the actual compiled code for that M-function. It is a
// static function and must only be called from one of the interface functions,
// appearing below.
//
//
// function varargout = strread(varargin);
//
static mwArray Mstrread(int nargout_, mwArray varargin) {
    mwLocalFunctionTable save_local_function_table_
      = &_local_function_table_strread;
    int nargin_ = nargin(-1, mwVarargin(varargin));
    mwArray varargout = mwArray::UNDEFINED;
    mwArray _T0_ = mwArray::UNDEFINED;
    mwArray nlhs = mwArray::UNDEFINED;
    mwArray ans = mwArray::UNDEFINED;
    //
    // %STRREAD Read formatted data from string.
    // %    A = STRREAD('STRING')
    // %    A = STRREAD('STRING','',N)
    // %    A = STRREAD('STRING','',param,value, ...)
    // %    A = STRREAD('STRING','',N,param,value, ...) reads numeric data from
    // %    the STRING into a single variable.  If the string contains any text data,
    // %    an error is produced.
    // %
    // %    [A,B,C, ...] = STRREAD('STRING','FORMAT')
    // %    [A,B,C, ...] = STRREAD('STRING','FORMAT',N)
    // %    [A,B,C, ...] = STRREAD('STRING','FORMAT',param,value, ...)
    // %    [A,B,C, ...] = STRREAD('STRING','FORMAT',N,param,value, ...) reads
    // %    data from the STRING into the variables A,B,C,etc.  The type of each
    // %    return argument is given by the FORMAT string.  The number of return
    // %    arguments must match the number of conversion specifiers in the FORMAT
    // %    string.  If there are fewer fields in the string than matching conversion
    // %    specifiers in the format string, an error is produced.
    // %
    // %    If N is specified, the format string is reused N times.  If N is -1 (or
    // %    not specified) STRREAD reads the entire string.
    // %
    // %    Example
    // %
    // %      s = sprintf('a,1,2\nb,3,4\n');
    // %      [a,b,c] = strread(s,'%s%d%d','delimiter',',')
    // %
    // %   See TEXTREAD for more examples and definition of terms.
    // %
    // %   See also TEXTREAD, SSCANF, FILEFORMATS.
    // 
    // %   Copyright 1984-2002 The MathWorks, Inc. 
    // %   $Revision: 1.6 $ $Date: 2002/06/05 20:10:15 $
    // 
    // %   Implemented as a mex file.
    // 
    // % do some preliminary error checking
    // error(nargchk(1,inf,nargin));
    //
    error(mwVarargin(nargchk(_mxarray0_, _mxarray1_, nargin_)));
    //
    // 
    // % allow empty string to pass through untouched
    // if isempty(varargin{1})
    //
    if (tobool(
          feval(
            mwValueVarargout(),
            mlxIsempty,
            mwVarargin(mwVa(varargin, "varargin").cell(_mxarray0_))))) {
        //
        // return;
        //
        goto return_;
    //
    // end
    //
    }
    //
    // 
    // if nargout == 0
    //
    if (nargout_ == 0) {
        //
        // nlhs = 1;
        //
        nlhs = _mxarray0_;
    //
    // else
    //
    } else {
        //
        // nlhs = nargout;
        //
        nlhs = nargout_;
    //
    // end
    //
    }
    _T0_ = colon(_mxarray0_, mwVv(nlhs, "nlhs"));
    //
    // 
    // [varargout{1:nlhs}]=dataread('string',varargin{:});
    //
    Ndataread(
      0,
      mwVarargout(varargout.cell(_T0_)),
      mwVarargin(_mxarray2_, mwVa(varargin, "varargin").cell(colon())));
    return_:
    return varargout;
}
