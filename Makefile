
# $Id: Makefile,v 1.1 2005/07/18 20:32:28 wangsl Exp wangsl $

.DEFAULT: .f .for .c .C .cpp .cc .f90
.SUFFIXES: .f .for .c .C .cpp .cc .f90

O = .

F77 = gfortran #mpif77
CC = gcc #mpicc
CCC = g++ #mpicxx

CFLAGS = -O3 -fPIC -fopenmp

FFLAGS = -O3 -fPIC -fopenmp

ifeq ($(HAVE_OPENMP), 1)
	CFLAGS += -DHAVE_OPENMP
endif

ifeq ($(HAVE_MPI), 1)
	CFLAGS += -DHAVE_MPI
	F77 = mpif77
	CC = mpicc
	CCC = mpicxx
endif

Link = $(CCC) $(CFLAGS) 

LIBS = 

EXENAME = pi

OBJS =  $(O)/pi.o

$(EXENAME) : $(OBJS) 
	$(Link) -o $(EXENAME) $(OBJS) $(LIBS)

$(O)/%.o: %.c
	cd $(O) ; $(CC) $(CFLAGS) -c $<
$(O)/%.o: %.cc
	cd $(O) ; $(CCC) $(CFLAGS) -c $<
$(O)/%.o: %.cpp
	cd $(O) ; $(CCC) $(CFLAGS) -c $<
$(O)/%.o: %.C
	cd $(O) ; $(CCC) $(CFLAGS) -c $<
$(O)/%.o: %.F
	cd $(O) ; $(F77) $(FFLAGS) -c $<
$(O)/%.o: %.for
	cd $(O) ; $(F77) $(FFLAGS) -c $<
$(O)/%.o: %.f90
	cd $(O) ; $(F90) $(FFLAGS) -c $<

clean:
	rm -f *.o *~ $(EXENAME) *.il *.mod *io.C depend

.PRECIOUS: %io.C %.C %.c %.f %.h $(O)/%.o


