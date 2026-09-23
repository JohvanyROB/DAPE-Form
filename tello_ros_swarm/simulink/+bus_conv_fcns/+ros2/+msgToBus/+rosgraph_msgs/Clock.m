function slBusOut = Clock(msgIn, slBusOut, varargin)
%#codegen
%   Copyright 2021-2022 The MathWorks, Inc.
    currentlength = length(slBusOut.clock);
    for iter=1:currentlength
        slBusOut.clock(iter) = bus_conv_fcns.ros2.msgToBus.builtin_interfaces.Time(msgIn.clock(iter),slBusOut(1).clock(iter),varargin{:});
    end
    slBusOut.clock = bus_conv_fcns.ros2.msgToBus.builtin_interfaces.Time(msgIn.clock,slBusOut(1).clock,varargin{:});
end
