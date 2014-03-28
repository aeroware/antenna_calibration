module c_interfaces

use iso_c_binding
implicit none

interface
    subroutine S_pol_single_prec(nthetas, nlambdas, reflectance, thetas, &
                                     wavelengths, nparms, parmvector)
        integer, value :: nthetas, nlambdas, nparms
        real(kind(1e0)), intent(in), dimension(nthetas) :: thetas 
        real(kind(1e0)), intent(in), dimension(nlambdas) :: wavelengths
        real(kind(1e0)), intent(in), dimension(nparms) :: parmvector
        real(kind(1e0)), intent(inout), dimension(nthetas, nlambdas) :: reflectance
    end subroutine S_pol_single_prec 
end interface

contains

subroutine calc_s_reflectance_single(reflectance, nthetas, nlambdas,             &
                                     thetas, wavelengths, intensities,           &
                                     nparms, parmvector) &
                                     bind(c, name='calc_s_reflectance_single')

!DEC$ ATTRIBUTES DLLEXPORT :: calc_s_reflectance_single

! The prototype to go into the C header file will be:
!
! void calc_s_reflectance_single(double *, int, int, double *, double *, 
!                                double *, int, double *);
!
! MATLAB will parse the arguments list and treat any arrays passed by reference 
! as function return values. Hence the MATLAB version of the routine (as seen
! by using 'libfunctions' with the '-full' option after the library name) 
! will be
!
! [doublePtr, doublePtr, doublePtr, doublePtr] = calc_s_reflectance_single ...
! (doublePtr, int32, int32, doublePtr, doublePtr, int32, doublePtr)
!
!and of course as usual in MATLAB the first returned value can be taken and
!the rest ignored.

! These are the C-compatible input and output variables
      integer(c_int), value :: nthetas, nlambdas, nparms
      real(c_double), intent(in), dimension(nthetas) :: thetas 
      real(c_double), intent(in), dimension(nlambdas) :: wavelengths
      real(c_double), intent(in), dimension(nthetas,nlambdas) :: intensities
      real(c_double), intent(in), dimension(nparms) :: parmvector
      real(c_double), intent(inout), dimension(nthetas, nlambdas) :: reflectance

! These are their native Fortran counterparts
      integer :: nthetas_F, nlambdas_F, nparms_F
      real(kind(1e0)), dimension(nthetas) :: thetas_F 
      real(kind(1e0)), dimension(nlambdas) :: wavelengths_F
      real(kind(1e0)), dimension(nparms) :: parmvector_F
      real(kind(1e0)), dimension(nthetas, nlambdas) :: reflectance_F 

! Convert the input variables to native Fortran
      nthetas_F=int(nthetas)
      nlambdas_F=int(nlambdas)
      nparms_F=int(nparms)
      thetas_F=real(thetas, kind(1e0))
      wavelengths_F=real(wavelengths, kind(1e0))
      parmvector_F=real(parmvector, kind(1e0))
      reflectance_F=real(reflectance, kind(1e0))

! Call the Fortran subroutine

call S_pol_single_prec(nthetas_F, nlambdas_F, reflectance_F,&
                       thetas_F, wavelengths_F, nparms_F, parmvector_F)

! Convert the output variable to C format
      reflectance=real(reflectance_F, c_double)

end subroutine calc_s_reflectance_single

end module c_interfaces