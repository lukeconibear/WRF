subroutine dcosq1f ( n, inc, x, lenx, wsave, lensav, work, lenwrk, ier )

!*****************************************************************************80
!
!! DCOSQ1F: real double precision forward cosine quarter wave transform, 1D.
!
!  Discussion:
!
!    DCOSQ1F computes the one-dimensional Fourier transform of a sequence
!    which is a cosine series with odd wave numbers.  This transform is
!    referred to as the forward transform or Fourier analysis, transforming
!    the sequence from physical to spectral space.
!
!    This transform is normalized since a call to DCOSQ1F followed
!    by a call to DCOSQ1B (or vice-versa) reproduces the original
!    array  within roundoff error.
!
!
!
!  Modified:
!
!     17 November 2007
!
!  Author:
!
!    Original real single precision by Paul Swarztrauber, Richard Valent.
!    Real double precision version by John Burkardt.
!
!  Reference:
!
!    Paul Swarztrauber,
!    Vectorizing the Fast Fourier Transforms,
!    in Parallel Computations,
!    edited by G. Rodrigue,
!    Academic Press, 1982.
!
!    Paul Swarztrauber,
!    Fast Fourier Transform Algorithms for Vector Computers,
!    Parallel Computing, pages 45-63, 1984.
!
!  Parameters:
!
!    Input, integer ( kind = 4 ) N, the number of elements to be transformed in
!    the sequence.  The transform is most efficient when N is a
!    product of small primes.
!
!    Input, integer ( kind = 4 ) INC, the increment between the locations, in
!    array R, of two consecutive elements within the sequence.
!
!    Input/output, real ( kind = 8 ) R(LENR); on input, containing the sequence
!    to be transformed, and on output, containing the transformed sequence.
!
!    Input, integer ( kind = 4 ) LENR, the dimension of the R array.
!    LENR must be at least INC*(N-1)+ 1.
!
!    Input, real ( kind = 8 ) WSAVE(LENSAV).  WSAVE's contents must be
!    initialized with a call to DCOSQ1I before the first call to routine
!    DCOSQ1F or DCOSQ1B for a given transform length N.  WSAVE's contents may
!    be re-used for subsequent calls to DCOSQ1F and DCOSQ1B with the same N.
!
!    Input, integer ( kind = 4 ) LENSAV, the dimension of the WSAVE array.
!    LENSAV must be at least 2*N + INT(LOG(REAL(N))) + 4.
!
!    Workspace, real ( kind = 8 ) WORK(LENWRK).
!
!    Input, integer ( kind = 4 ) LENWRK, the dimension of the WORK array.
!    LENWRK must be at least N.
!
!    Output, integer ( kind = 4 ) IER, error flag.
!    0, successful exit;
!    1, input parameter LENR   not big enough;
!    2, input parameter LENSAV not big enough;
!    3, input parameter LENWRK not big enough;
!    20, input error returned by lower level routine.
!
  implicit none

  integer ( kind = 4 ) inc
  integer ( kind = 4 ) lensav
  integer ( kind = 4 ) lenwrk

  integer ( kind = 4 ) ier
  integer ( kind = 4 ) ier1
  integer ( kind = 4 ) n
  integer ( kind = 4 ) lenx
  real ( kind = 8 ) ssqrt2
  real ( kind = 8 ) tsqx
  real ( kind = 8 ) work(lenwrk)
  real ( kind = 8 ) wsave(lensav)
  real ( kind = 8 ) x(inc,*)

  ier = 0

  if ( lenx < inc * ( n - 1 ) + 1 ) then
    ier = 1
    call xerfft ( 'dcosq1f', 6 )
    return
  end if

  if ( lensav < 2 * n + int ( log ( real ( n, kind = 8 ) ) ) + 4 ) then
    ier = 2
    call xerfft ( 'dcosq1f', 8 )
    return
  end if

  if ( lenwrk < n ) then
    ier = 3
    call xerfft ( 'dcosq1f', 10 )
    return
  end if

  if ( n < 2 ) then
    return
  end if

  if ( n == 2 ) then
    ssqrt2 = 1.0D+00 / sqrt ( 2.0D+00 )
    tsqx = ssqrt2 * x(1,2)
    x(1,2) = 0.5D+00 * x(1,1) - tsqx
    x(1,1) = 0.5D+00 * x(1,1) + tsqx
    return
  end if

  call dcosqf1 ( n, inc, x, wsave, work, ier1 )

  if ( ier1 /= 0 ) then
    ier = 20
    call xerfft ( 'dcosq1f', -5 )
    return
  end if

  return
end
