using MTIWrapper
using Test
using CSV

cwd = dirname(@__FILE__)
test_file = "$cwd/abstracts.txt"
output_file = "$cwd/mti_results_work.txt"

if isfile("$cwd/mti_results_work.txt")
    rm("$cwd/mti_results_work.txt")
end

mti_dir = "$cwd/tmp"
MTIWrapper.install_web_api(mti_dir)
MTIWrapper.mti_batch_query(mti_dir, ENV["NCBI_EMAIL"], ENV["UMLS_USER"], ENV["UMLS_PSSWD"], 
                           test_file, output_file)
header = ["uid","term", "cui", "score", "type", "misc", "location", "path"]
df = CSV.read(output_file, header = header, datarow=3, delim='|')

@test size(df) == (18,8)