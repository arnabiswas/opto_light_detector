function [on_off_list_out] = filterLight(on_off_list_in, debug)
    %FILTERLIGHT Summary of this function goes here
    %   use debug to make descriptive plots to help set parameters
    
    %Removing consecutive ones based on assumption that the opto light flased
    %and consecutive ones means something else like experimenter hand in image
    on_off_list_in_filt = filterConsecutiveOnes(on_off_list_in);
    on_off_list_out = filterLightSignal(on_off_list_in_filt);
    
    if debug
        figure 
        plot(on_off_list_in)
        hold on
        plot(on_off_list_in_filt)
        plot(on_off_list_out,'g', 'LineWidth', 2)
    end
end