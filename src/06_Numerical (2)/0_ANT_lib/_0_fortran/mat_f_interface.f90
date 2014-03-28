module ant_lib
!---------------------------------------------------------------------
!  antenna grid routines in support of the matlab library
!  Module containing definitions and c binding conversion
!---------------------------------------------------------------------
use iso_c_binding

implicit none

interface 
    subroutine new_nodes_calc(nodes , Geom, dist) 
        real(kind=8), intent(out), dimension(:) :: nodes
        real(kind=8), intent(in), dimension(:,:) :: Geom
        real(kind=8), intent(in) :: dist
    end subroutine new_nodes_calc
end interface

interface 
    subroutine new_geom_calc(nodes, Geom) 
        real(kind=8), intent(in), dimension(:) :: nodes
        real(kind=8), dimension(:,:) :: Geom
    end subroutine new_geom_calc
end interface

contains

subroutine det_n_grid(n_nodes_C, Geom_C, rows_C, dist_C) bind(c, name='det_n_grid')
!DEC$ ATTRIBUTES DLLEXPORT :: det_n_grid

! iso_c_bindings for transformation of the variables
! header file for matlab: ant-f-lib.h

! These are the C-compatible input and output variables
    integer(c_long_long), value :: rows_C
    real(c_double), value :: dist_C
    real(c_double), intent(out), dimension(rows_C) :: n_nodes_C
!    real(c_double), intent(in), dimension(rows_C,3) :: Geom_C
    real(c_double), dimension(rows_C,3) :: Geom_C

! These are their native Fortran counterparts
    real(kind=8), dimension(rows_C) :: n_nodes_F
    real(kind=8), dimension(rows_C,3) :: Geom_F
    real(kind=8) :: dist_F

! Convert the input variables to native Fortran
    n_nodes_F=real(n_nodes_C, kind=8)
    Geom_F=real(Geom_C, kind=8)
    dist_F=real(dist_C, kind=8)

! calculate the new node vector using a KD-Tree
    call new_nodes_calc (n_nodes_F, Geom_F, dist_F)
!    call new_geom_calc (n_nodel_F, Geom_F)

! Convert the output variable to C format
    n_nodes_C=real(n_nodes_F, c_double)
    Geom_C=real(Geom_F, c_double)

end subroutine det_n_grid

end module ant_lib
