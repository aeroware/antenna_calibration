program fmcGetCurrent
    
!   program [CS,Z_a]=fmcGetCurrent(ant, f,volt,integral,inte)
!
!   This function computes the currents of the wiregrid structure stored in
!   ant and saves it in the current structure CS together with the 
!   frequency and the feed position used for the calculation. It uses the 
!   method of moments. The antennaimpedance is also calculated and stored 
!   in Z_a
!
!   ant...antenna structure
!   f...frequency
!   volt...excitation voltage on feeds
!   integral...method of integral evaluation
!   inte...number of integration steps

implicit none

! constants

logical err

real(kind=8), parameter:: PI=3.141592653589793
real(kind=8),parameter :: MU=4*PI*1e-7    ! henry/meter...free space
real,parameter:: EPSILON0=8.8542e-12 ! farad/meter...free space
complex, parameter:: imath=(0,1)

!  parameter

integer::nSegs,nNodes,nFeed
integer n,m,p
integer rval
integer inte
real(kind=8)::f ! frequency
real(kind=8)::freqrelsqu,ionrelsequ ! omega_pe^2/omega^2
real(kind=8)::ioneffect! take effect of ions into account
real(kind=8):: Z0  ! impedance of free space corrected for plasma
real(kind=8)::epsilon,epsilonr
real(kind=8)::volt ! excitation voltage
real(kind=8)::wavelength,k,omega ! wavelength, wave number, frequency
real(kind=8) a,a_rel !radius, relative radius
real(kind=8) conductivity
real(kind=8) length,seglen !length
real(kind=8) , dimension(3)::diff

complex(kind=8), allocatable, dimension(:):: I      ! current vector
complex(kind=8), allocatable, dimension(:):: E      ! electric field
complex(kind=8), allocatable, dimension(:,:):: Z    ! impedance matrix
real(kind=8), allocatable, dimension(:):: l,l_rel      ! length of segment, relative length of segment
real(kind=8), allocatable, dimension(:,:):: mid, midpoint      ! midpoint of segment
real(kind=8), allocatable, dimension(:,:):: r,r_rel   ! distance between 2 segments
real(kind=8), allocatable, dimension(:)::dist
complex(kind=8), allocatable, dimension(:,:):: G
complex(kind=8), allocatable, dimension(:)::Gmn
complex(kind=8) heff

real(kind=8), allocatable, dimension(:,:) :: nodes
integer, allocatable, dimension(:,:) :: segs
integer, allocatable, dimension(:) :: feeds

write(*,*) 'Frequency : '
read(*,*) f

write(*,*) 'Product omega_pe/omega : '
read(*,*) freqrelsqu

write(*,*) 'Take ions into account ? (1/0) : '
read(*,*) ioneffect

write(*,*) 'Excitation voltage : '
read(*,*) volt

write(*,*) 'Number of integration steps : '
read(*,*) inte


!   setup matrices



ionrelsequ=ioneffect*freqrelsqu/2000
epsilonr=(1-freqrelsqu-ionrelsequ) 
epsilon=EPSILON0*epsilonr

Z0=sqrt(mu/EPSILON0)
wavelength=3e8/(f*sqrt(epsilonr));
k=2*PI/wavelength;
omega=2*PI*f;

open(unit=8,file='grid.mec',status = 'old',action = 'read',iostat=rval)

if(rval/=0)then
    write(*,*) 'ERROR - unable to open file'
    stop
end if

read(8,*)nNodes
read(8,*)nSegs
read(8,*)conductivity
read(8,*)a
read(8,*)length
read(8,*)nFeed

write(*,*) 'nNodes : ',nNodes
write(*,*) 'nSegs : ',nSegs
write(*,*) 'Conductivity : ',conductivity
write(*,*) 'Radius : ',a
write(*,*) 'Length : ',length
write(*,*) 'nFeed : ',nFeed,'\n'

allocate(I(nSegs))
allocate(E(nSegs))
allocate(Z(nSegs,nSegs))
allocate(l(nSegs))
allocate(l_rel(nSegs))
allocate(r(nSegs,nSegs))
allocate(r_rel(nSegs,nSegs))
allocate(mid(nSegs,3))
allocate(nodes(nNodes,3))
allocate(segs(nSegs,2))
allocate(feeds(nFeed))
allocate(midpoint(inte,3))
allocate(dist(inte))

I=0
E=0
Z=0
l=0
r=0
r_rel=0

do n=1,nFeed
    read(8,*)feeds(n)
end do
    
do n=1,nNodes
    read(8,*)nodes(n,:)
end do

do n=1,nSegs
    read(8,*)segs(n,:)
end do

close(unit=8)


a_rel=a/wavelength 

!   construct impedance matrix

do n=1,nSegs
    diff=(nodes(segs(n,2),:)-nodes(segs(n,1),:))
    l(n)=sqrt(dot_product(diff,diff))
    mid(n,:)=(nodes(segs(n,1),:)+nodes(segs(n,2),:))/2
end do

l_rel=l/wavelength;

! compute distance between segments

do m=1,nSegs
    do n=1,nSegs        
        diff=(mid(n,:)-mid(m,:))
        r(m,n)=sqrt(dot_product(diff,diff)+a**2)
    end do
end do

r_rel=r/wavelength;

! constructing the integrand

allocate(G(nSegs,nSegs))
allocate(Gmn(inte))
G=0
        

! integrating

        
do m=1,nSegs
    write(*,*) 'Working on segment ',m
    do n=1,nSegs
      !              % do integration
                              
        seglen=l(n)/inte;
                    
        do p=1,inte
            midpoint(p,:)=nodes(segs(n,1),:)+(p-0.5)*(nodes(segs(n,2),:)-nodes(segs(n,1),:))/inte
                        
            diff=midpoint(p,:)-mid(m,:)
            dist(p)=sqrt(dot_product(diff,diff)+a**2)
                        
            Gmn(p)=(Z0*wavelength)/(imath*8*pi**2)*(exp(-imath*k*dist(p))/dist(p)**5)&
            &*((1+imath*k*dist(p))*(2*dist(p)**2-3*a**2)+k**2*a**2*dist(p)**2)       
        end do
          
        Gmn=Gmn*seglen
        G(m,n)=sum(Gmn);
   end do
end do


E(feeds)=volt/l(feeds)


call linEquComp(G,E,nSegs,nSegs,err)

if(err) then
    write(*,*) 'ERROR - singular matrix'
    stop
end if

I=-E


do n=1,nSegs
write(*,*)I(n)
end do


! Antenna Impedance

write(*,*) 'Za = ',volt/I(feeds)
diff=(mid(1,:)-l(1)/2)-(mid(nSegs,:)+l(nSegs)/2)
heff= sqrt(dot_product(diff,diff)+a**2)/2
write(*,*) 'heff= ', heff
write(*,*) 'Radiation Resistance of ideal thin dipole = ', 20*(heff*k)**2

! save 

!CS=struct(...
 !   'I',[],...
  !  'feeds',[],...
   ! 'f',0 ...
   ! );
   
open(unit=8,file='mec.out',status = 'unknown',action = 'write',iostat=rval)

if(rval/=0)then
    write(*,*) 'ERROR - unable to open file'
    stop
end if

write(8,*) nSegs
write(8,*) nFeed
write(8,*) f

do n=1,nSegs
    write(8,*)real(I(n)),aimag(I(n))
end do

do n=1,nFeed
    write(8,*)feeds(n)
end do

close(8)
end program fmcGetCurrent

!--------------------------------------------------------------------------------------------

subroutine linEqu(a,b,nDim,n,err)
    
! Solve a system of n linear equations, using Gaußian elimination with 
! max pivoting
    
    implicit none
    
    integer, intent(in)::ndim   ! dimension of a,b
    integer, intent(in)::n      ! number of equations
    logical, intent(out)::err   ! error flag
    real(kind=8), intent(inout), dimension(nDim,nDim)::a    ! coefficient matrix
    real(kind=8), intent(inout), dimension(nDim)::b         ! in: rhs of equations
                                                            ! out: solution vector
                                                            
    real, parameter :: epsilon=1.0e-16
    real(kind=8)  factor, temp
    real(kind=8), dimension(ndim)::temp2
    integer irow, ipeak, jrow, kcol
    
    mainloop:do irow=1,n
        ipeak=irow
        maxPivot: do jrow=irow+1,n
            if(abs(a(jrow,irow))>abs(a(ipeak,irow))) then
                ipeak=jrow
            end if
        end do maxPivot
        
        singular: if(abs(a(ipeak,irow))< epsilon) then
            err=.true.
            return
        end if singular    
        
        swap:if(ipeak/=irow)then
            temp2=a(ipeak,:)
            a(ipeak,:)=a(irow,:)
            a(irow,:)=temp2
            temp=b(ipeak)
            b(ipeak)=b(irow)
            b(irow)=temp
        end if swap
        
        eliminate: do jrow=1,n
            if(jrow/=irow) then
                factor = -a(jrow,irow)/a(irow,irow)
                
                a(jrow,:)=a(irow,:)*factor+a(jrow,:)
                b(jrow)=b(irow)*factor+b(jrow)
            end if
        end do eliminate
    end do mainloop
    
    divide: do irow=1,n
        b(irow)=b(irow)/a(irow,irow)
        a(irow,irow)=1
    end do divide
    
    err=.false. 
end subroutine linEqu

!-------------------------------------------------------------------------------------------


subroutine linEquComp(a,b,nDim,n,err)
    
! Solve a system of n linear equations, using Gaußian elimination with 
! max pivoting;
    
    implicit none
    
    integer, intent(in)::ndim   ! dimension of a,b
    integer, intent(in)::n      ! number of equations
    logical, intent(out)::err   ! error flag
    complex(kind=8), intent(inout), dimension(nDim,nDim)::a    ! coefficient matrix
    complex(kind=8), intent(inout), dimension(nDim)::b         ! in: rhs of equations
                                                            ! out: solution vector
                                                            
    real, parameter :: epsilon=1.0e-16
    complex(kind=8)  factor
    complex(kind=8)  temp
    complex(kind=8), dimension(ndim)::temp2
    integer irow, ipeak, jrow, kcol
    
    mainloop:do irow=1,n
        ipeak=irow
        maxPivot: do jrow=irow+1,n
            if(abs(a(jrow,irow))>abs(a(ipeak,irow))) then
                ipeak=jrow
            end if
        end do maxPivot
        
        singular: if(abs(a(ipeak,irow))< epsilon) then
            err=.true.
            return
        end if singular    
        
        swap:if(ipeak/=irow)then
            temp2=a(ipeak,:)
            a(ipeak,:)=a(irow,:)
            a(irow,:)=temp2
            temp=b(ipeak)
            b(ipeak)=b(irow)
            b(irow)=temp
        end if swap
        
        eliminate: do jrow=1,n
            if(jrow/=irow) then
                factor = -a(jrow,irow)/a(irow,irow)
                
                a(jrow,:)=a(irow,:)*factor+a(jrow,:)
                b(jrow)=b(irow)*factor+b(jrow)
            end if
        end do eliminate
    end do mainloop
    
    divide: do irow=1,n
        b(irow)=b(irow)/a(irow,irow)
        a(irow,irow)=1
    end do divide
    
    err=.false. 
end subroutine linEquComp

!-------------------------------------------------------------------------------------------

