######################################################################
#
#    $Source$
#
#    $Revision$
#    $Date$
#
#    $Author$
#
#    Copyright (C) 2003,2004 James Steven Jenkins
#    
######################################################################

# This file is syntactic sugar for accessing the Ruby comedilib
# extension library generated by SWIG. The syntactic sugar is in
# four forms:
#
# (1)  Method names without the 'comedi_' prefix. The Comedi module
# disambiguates the namespace.
#
# (2)  Instance methods that take an explicit receiver instead of
# passing the target object as an initial pointer. For example:
# comedi_close(dev) can be written as dev.close.
#
# (3)  A pre-defined IO object and an accessor method to simplify
# reading from the file descriptor associated with the comedi device.
# Data from comedi device dev can be accessed with dev.ios.read.
#
# (4)  A ComediError exception class. If the underlying comedi
# function returns an error indication, the ruby method will raise
# ComediError.

require 'comedi.so'

include Comedi

# SWIG::TYPE_p_comedi_t is returned by Comedi::open

class SWIG::TYPE_p_comedi_t

    # create an IO object to access the comedi_t fileno

    def ios
	def self.ios
	    @ios
	end
	@ios = IO.new(fileno, 'r')
    end
end

# ComediError is raised by methods whose underlying comedi functions return
# indication of an error.

class ComediError < SystemCallError

    def initialize
	@comedi_errno = Comedi::errno
    end

    attr_reader :comedi_errno
end

module Comedi

private

    # wrap_method is the basis for wrap_module_method and
    # wrap_instance_method.

    def wrap_method(mod, name, err, arglist)
	wrap_def = %Q{
	    def #{name}(*args)
		ret = comedi_#{name}(#{arglist})
	}
	unless err == :none
	    wrap_def << %Q{ raise ComediError.new if }
	    case err
		when :neg
		    wrap_def << %Q{ ret < 0 }
		when nil
		    wrap_def << %Q{ ret.nil?  }
		else
		    wrap_def << %Q{ ret == #{err} }
	    end
	end
	wrap_def << %Q{
		ret
	    end
	}
	mod.module_eval wrap_def
    end

    # wrap_module_method defines Comedi module methods without the
    # unnecessary comedi_ prefix. The wrapped method raises
    # ComediError if the return value equals a specified value.

    def wrap_module_method(mod, name, err)
	wrap_method(mod, name, err, '*args')
    end

    # wrap_instance_method defines instance methods for any of several
    # classes. It removes the comedi_ prefix and allows use of an
    # explicit receiver.  The wrapped method raises ComediError
    # if the return value equals a specified value.

    def wrap_instance_method(mod, name, err)
	wrap_method(mod, name, err, 'self, *args')
    end

    # This struct holds information for methods with return class and
    # error indication.

    Method_group = Struct.new(:class, :err, :names)

    # Wrap Comedi module methods

    [   
	# Comedi module methods that return nil on error.

	Method_group.new(Comedi, nil, %w{
	    open
	    parse_calibration_file
	}),

	# Comedi module methods that do not indicate errors.

	Method_group.new(Comedi, :none, %w{
	    loglevel
	    perror
	    strerrno
	    errno
	    to_phys
	    from_phys
	    set_global_oor_behavior
	}),
    ].each do |d|
	d.names.each do |n|
	    wrap_module_method(d.class, n, d.err)
	end
    end

    # Wrap Instance methods

    [   
	# SWIG::TYPE_p_comedi_t methods that return -1 on error.

	Method_group.new(SWIG::TYPE_p_comedi_t, -1, %w{
	    close
	    fileno
	    get_subdevice_type
	    find_subdevice_by_type
	    get_read_subdevice
	    get_write_device
	    get_subdevice_flags
	    get_n_channels
	    range_is_chan_specific
	    maxdata_is_chan_specific
	    get_n_ranges
	    find_range
	    get_buffer_size
	    get_max_buffer_size
	    set_buffer_size
	    trigger
	    do_insnlist
	    do_insn
	    lock
	    unlock
	    data_read
	    data_read_delayed
	    data_write
	    dio_config
	    dio_read
	    dio_write
	    dio_bitfield
	    get_cmd_src_mask
	    get_cmd_generic_timed
	    cancel
	    command
	    command_test
	    poll
	    set_max_buffer_size
	    get_buffer_contents
	    mark_buffer_read
	    get_buffer_offset
	}),

	# SWIG::TYPE_p_comedi_t methods that return 0 on error.

	Method_group.new(SWIG::TYPE_p_comedi_t, 0, %w{
	    get_maxdata
	}),

	# SWIG::TYPE_p_comedi_t methods that return <0 on error.

	Method_group.new(SWIG::TYPE_p_comedi_t, :neg, %w{
	    apply_calibration
	    apply_parsed_calibration
	}),

	# SWIG::TYPE_p_comedi_t methods that return nil on error.

	Method_group.new(SWIG::TYPE_p_comedi_t, nil, %w{
	    get_driver_name
	    get_board_name
	    get_range
	    get_default_calibration_path
	}),

	# SWIG::TYPE_p_comedi_t methods that do not indicate errors.

	Method_group.new(SWIG::TYPE_p_comedi_t, :none, %w{
	    get_n_subdevices
	    get_version_code
	    data_read_hint
	}),

	# Comedi_sv_t methods that return -1 on errors.

	Method_group.new(Comedi_sv_t, -1, %w{
	    sv_init
	    sv_update
	    sv_measure
	}),

	# Comedi_calibration_t methods that do not indicate errors.

	Method_group.new(Comedi_calibration_t, :none, %w{
	    cleanup_calibration_file
	})
    ].each do |d|
	d.names.each do |n|
	    wrap_instance_method(d.class, n, d.err)
	end
    end
end