
#include <iostream>
using namespace std;
#include <iomanip>
#include <cassert>
#include <cstdlib>
#include <cstdio>

#ifdef HAVE_OPENMP
#include <omp.h>
#endif

#ifdef HAVE_MPI
#include <mpi.h>
#endif

inline double f(const double &x) 
{ 
  return 4.0/(1.0 + x*x);
}

inline double block_sum(const double &x1, const double &dx, const long &n_grids)
{
  double s = 0.0;
#ifdef HAVE_OPENMP
#pragma omp parallel for			\
  default(shared) schedule(static, 100)		\
  reduction(+:s)
#endif
  for(long i = 0; i < n_grids; i++) {
    double x = x1 + i*dx;
    s += f(x);
  }
  
  return s*dx;
}

double calculate_pi()
{
  const double x1 = 0.0;
  const double x2 = 1.0;
  const long n = 2147483648;
  const double dx = (x2-x1)/(n-1);
  
  long n_grids = n;
  double xL = x1;
  
#ifdef HAVE_MPI
  int mpi_thread_id = -100;
  MPI_Comm_rank(MPI_COMM_WORLD, &mpi_thread_id);
  
  int n_mpi_threads = -100;
  MPI_Comm_size(MPI_COMM_WORLD, &n_mpi_threads);
  
  n_grids = n_grids/n_mpi_threads;
  xL = x1 + mpi_thread_id*n_grids*dx;
  
  if(mpi_thread_id == n_mpi_threads-1) {
    n_grids = n - mpi_thread_id*n_grids;
  }
#endif
  
  double s = block_sum(xL, dx, n_grids);
  
#ifdef HAVE_MPI
  double s_buf = 0.0;
  assert(MPI_Allreduce(&s, &s_buf, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD) == MPI_SUCCESS);
  s = s_buf;
#endif
  
  double pi = s - 0.5*(f(0.0) + f(1.0))*dx;
  
  return pi;
}

int main(int argc, char *argv[])
{
#ifdef HAVE_MPI
  MPI_Init(&argc, &argv);
  
  int n_procs = -100;
  MPI_Comm_size(MPI_COMM_WORLD, &n_procs);
  
  int rank_id = -100;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank_id);
  
  if(rank_id > 0) freopen("/dev/null", "w", stdout);
  
  cout << " Total MPI process number = " << n_procs << endl;
  const char *omp_num_threads = getenv("OMP_NUM_THREADS");
  if(omp_num_threads)
    cout << " OMP_NUM_THREADS = " << omp_num_threads << endl;
#endif
  
  for(int i = 0; i < 100; i++) {
    double pi =  calculate_pi();
    cout << setw(4) << i << " " << setw(16) << setprecision(14) << pi << endl;
  }
  
#ifdef HAVE_MPI
  MPI_Finalize();
#endif

  return 0;
}
