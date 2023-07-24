
debug = false;

%point to folder with all .xlsx files that have the OptoLight column
opto_processed_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics/opto_out/';


opto_processed_files = dir(fullfile(opto_processed_path, '*.xlsx'));

for i = 1:numel(opto_processed_files)
    fprintf(opto_processed_files(i).name)
    fprintf('\n')
    T = readtable(fullfile(opto_processed_path, opto_processed_files(i).name));
    on_off_list_in =  T.OptoLight;
    on_off_list_out= filterLight(on_off_list_in, debug);
    T.OptoLightFiltered = on_off_list_out;
    Filename = fullfile(opto_processed_path,opto_processed_files(i).name);
    writetable(T, Filename);
end
