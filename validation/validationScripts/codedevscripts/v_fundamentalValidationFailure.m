function varargout = v_fundamentalValidationFailure(varargin)
%
% Example validation script that demonstrates usage of the fundemantal failure feature. 
%

    varargout = UnitTest.runValidationRun(@ValidationFunction, varargin);
end

%% Function implementing the isetbio validation code
function ValidationFunction(runTimeParams)
      
    % Simulate fundamental failure here
    if (true)
        UnitTest.validationRecord('FUNDAMENTAL_CHECK_FAILED', 'Fundamental failure message goes here.');
        return;
    end
    
    UnitTest.validationRecord('PASSED',  'all right to here');
    UnitTest.validationData('dummyData', ones(100,10));
    
    % Plotting
    if (runTimeParams.generatePlots)
       figure(1);
       clf;
       plot(1:10, 1:10, 'r-');
       axis 'square'
       drawnow;
    end
    
end