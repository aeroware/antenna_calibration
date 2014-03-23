bin_PROGRAMS = nec2diff nec2++
lib_LIBRARIES =  libnecpp.a

#necpp_SOURCES = nec2cpp.cpp

nec2___SOURCES = c_evlcom.cpp c_evlcom.h c_geometry.cpp c_geometry.h c_ggrid.cpp c_ggrid.h c_plot_card.cpp c_plot_card.h common.h electromag.h math_util.h matrix_algebra.cpp matrix_algebra.h matrix_algebra.o misc.cpp misc.h nec.h nec2cpp.cpp nec2cpp.h nec_context.cpp nec_context.h nec_exception.h nec_ground.cpp nec_ground.h nec_output.cpp nec_output.h nec_radiation_pattern.cpp nec_radiation_pattern.h nec_results.h safe_array.h nec_exception.cpp XGetopt.cpp XGetopt.h

nec2diff_SOURCES =  AntennaInput.h BaseInput.h CurrentInput.h necDiff.cpp PowerBudget.h RadiationInput.h

libnecpp_a_SOURCES = c_evlcom.cpp c_evlcom.h c_geometry.cpp c_geometry.h c_ggrid.cpp c_ggrid.h c_plot_card.cpp c_plot_card.h common.h electromag.h math_util.h matrix_algebra.cpp matrix_algebra.h misc.cpp misc.h nec_context.cpp nec_context.h nec_ground.cpp nec_ground.h nec_output.cpp nec_output.h nec_radiation_pattern.cpp nec_radiation_pattern.h nec_results.h safe_array.h libNEC.cpp
noinst_HEADERS = nec.h nec_exception.h

# set the include path found by configure
INCLUDES= $(all_includes)

# the library search path.
#necpp_LDFLAGS = $(all_libraries) 
#libnecpp_a_LDFLAGS = -all-static 
nec2___LDADD = -lblas -latlas -llapack_atlas
