
!---------------------------------------------------------------------
!  antenna grid routines in support of the matlab library
!  actual calculations and geometrical functions and subroutines
!---------------------------------------------------------------------
subroutine new_nodes_calc(nodes , Geom, dist)
use kdtree2_module

implicit none
! in-out variables
    real(kind=8), intent(out), dimension(:) :: nodes
!    real(kind=8), intent(in), dimension(:,:) :: Geom
    real(kind=8), dimension(:,:) :: Geom
    real(kind=8), intent(in) :: dist

! Create the tree variables
    type(kdtree2), pointer            :: tree
    type(kdtree2_result), allocatable :: results(:)
    integer                           :: n_results, idxin
    integer                           :: n_patch_num = 1

! other variables
    real(kind=8), dimension(size(nodes,1)) :: nodes_to_keep
!    real(kind=8), dimension(size(Geom,1),3) :: new_Geom

! Initialize the new nodes and create the tree
    nodes=0
    tree => kdtree2_create(transpose(Geom),3,.true.,.true.)

! loop 
!new_Geom = Geom
nodes_to_keep = 0
!idxin = 1
!n_patch_num = 1

DO idxin = 1, size(nodes,1)
    IF (nodes(idxin) .EQ. 0) THEN
        n_results = kdtree2_r_count_around_point(tp=tree,idxin=idxin,&
                                                 correltime=-1,r2=dist**2)
        allocate(results(n_results))
        call kdtree2_r_nearest_around_point(tp=tree,idxin=idxin,correltime=-1,&
                                            r2=dist**2,nfound=n_results,&
                                            nalloc=n_results,results=results)
        nodes(results(:)%idx) = n_patch_num
        nodes_to_keep(n_patch_num) = idxin
        Geom(n_patch_num,:) = Geom(idxin,:)
        n_patch_num=n_patch_num+1
        deallocate(results)
    END IF
END DO
lbound
!    Geom = reshape(Geom,n_patch_num,3)

    call kdtree2_destroy(tree)
    deallocate(tree)

end subroutine new_nodes_calc

! calculate the new geometry points using a new_nodes vcector
! IN : nodes , Geom
! OUT: Geom
subroutine new_geom_calc(nodes,Geom)
    implicit none

    real(kind=8), intent(out), dimension(:) :: nodes
    real(kind=8), dimension(:,:) :: Geom
    
    

end subroutine new_geom_calc
