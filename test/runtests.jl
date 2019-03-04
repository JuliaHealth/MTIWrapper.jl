using MTIWrapper
using Test
using CSV

cwd = dirname(@__FILE__)


mti_dir = "$cwd/tmp"
MTIWrapper.install_web_api(mti_dir)
test_df = CSV.read("$cwd/test_df.txt")

@testset "Title and Abstract" begin
    ti_abs_file = "$cwd/ti-abs.txt"
    output_file = "$cwd/ti-abs-results.txt"

    rm(ti_abs_file, force=true)
    rm(output_file, force=true)

    MTIWrapper.title_abstracts_to_request_file(test_df, ti_abs_file)
    MTIWrapper.mti_batch_query(mti_dir, ENV["NCBI_EMAIL"], ENV["UMLS_USER"], ENV["UMLS_PSSWD"], 
            ti_abs_file, output_file)
    header = ["uid","term", "cui", "score", "type", "misc", "location", "path"]
    df = CSV.read(output_file, header = header, datarow=3, delim='|')

    println(df)
    @test size(df) == (34,8)
end

@testset "Abstract" begin
    abs_file = "$cwd/abs.txt"
    output_file = "$cwd/abs-results.txt"

    rm(abs_file, force=true)
    rm(output_file, force=true)

    MTIWrapper.abstracts_to_request_file(test_df, abs_file)
    MTIWrapper.mti_batch_query(mti_dir, ENV["NCBI_EMAIL"], ENV["UMLS_USER"], ENV["UMLS_PSSWD"], 
            abs_file, output_file)
    header = ["uid","term", "cui", "score", "type", "misc", "location", "path"]
    df = CSV.read(output_file, header = header, datarow=3, delim='|')

    println(df)
    @test size(df) == (28,8)
end