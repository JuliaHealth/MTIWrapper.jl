using MTIWrapper
using Test

cwd = dirname(@__FILE__)
rm("$cwd/mti_results_work.txt")
mti_dir = "$cwd/tmp"
MTIWrapper.install_web_api(mti_dir)
MTIWrapper.mti_batch_query(mti_dir, ENV["NCBI_EMAIL"], ENV["UMLS_USER"], ENV["UMLS_PSSWD"], 
                           "$cwd/abstracts.txt", "$cwd/mti_results_work.txt")