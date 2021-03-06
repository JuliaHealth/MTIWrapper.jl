module MTIWrapper

"""
    function install_web_api(root_dir)
Installs MTI Java jar to specified location
"""
function install_web_api(root_dir; api_version="SKR_Web_API_V2_3")

    
    module_dir = dirname(@__FILE__)
    curr_dir = Base.pwd()

    @info "MTIWrapper: Current Directory $module_dir"

    api_dir = "$root_dir/$api_version"

    if !isdir(root_dir)
        mkdir(root_dir)
    else
        if isdir(api_dir)
           rm(api_dir, recursive = true, force = true)
           rm("$api_dir.jar")
        end
    end

    println("Dowloading fresh copy of sources")
    # get sources and expand
    cd(root_dir)
    download("https://ii.nlm.nih.gov/Web_API/$api_version.jar", "$api_version.jar")
    run(`java sun.tools.jar.Main xf $api_version.jar`)

    # We have modified our class to pass credentials as an input - we'll put it in examples folder
    # so that MTI default compilation scripts work
    cp("$module_dir/GenericBatchCustom.java", "$api_dir/examples/GenericBatchCustom.java", force=true) 
    cp("$module_dir/generic_batch.sh", "$root_dir/generic_batch.sh", force=true) 

    # compile
    # cd("SKR_Web_API_V2_3")
    run(`chmod +x $api_dir/compile.sh $api_dir/run.sh $api_dir/build.sh`)
    run(`$api_dir/compile.sh $api_dir/examples/GenericBatchCustom.java`)

    cd(curr_dir)
    println(pwd())

end

"""
    function mti_batch_query(mti_java_dir, email, username, password, in_file, out_file)
Send a batch query to MTI. Use function `abstracts_to_request_file` to generate `in_file`
"""
function mti_batch_query(mti_java_dir, email, username, password, in_file, out_file)

    run(`$mti_java_dir/generic_batch.sh $mti_java_dir $email $username $password $in_file $out_file`)
end



"""
    abs_to_request_file()

Write all abstracts in a dataframe, to a file to be used for MTI batch query.
The format is:

UI - pmid
AB - abstract_text
"""
function abstracts_to_request_file(df, out_file; uid_column::Symbol = :pmid, abstract_column::Symbol = :abstract)

    #call MTI
    open(out_file, "w") do file

        for row in eachrow(df)
            uid = row[uid_column]
            abstract_text = row[abstract_column]

            if ismissing(abstract_text)
                println( "Skipping empty abstract for uid: ", uid)
                continue
            end

            # convert to ascii - all unicode caracters to " "
            abstract_ascii = replace(abstract_text, r"[^\u0000-\u007F]"=>"")
            write(file, "UI  - $uid \n")
            write(file, "AB  - $abstract_ascii \n \n")
        end
    end

end

"""
    abs_to_request_file()

Write all abstracts in a dataframe, to a file to be used for MTI batch query.
The format is:

UI - pmid
AB - abstract_text
"""
function title_abstracts_to_request_file(df, out_file; uid_column::Symbol = :pmid, 
                                         title_column::Symbol = :title, abstract_column::Symbol = :abstract)

    #call MTI
    open(out_file, "w") do file

        for row in eachrow(df)
            uid = row[uid_column]
            abstract_text = row[abstract_column]
            title_text = row[title_column]

            write(file, "UI  - $uid \n")

            if !ismissing(title_text) 
                # convert to ascii - all unicode caracters to " "
                title_ascii = replace(title_text, r"[^\x00-\x7F]+"=>"")
                write(file, "TI  - $title_ascii \n")
            end
                
           if !ismissing(abstract_text)
                # convert to ascii - all unicode caracters to " "
                abstract_ascii = replace(abstract_text, r"[^\x00-\x7F]+"=>"")
                abstract_ascii = replace(abstract_ascii, "Abstract: "=>"")
                write(file, "AB  - $abstract_ascii \n \n")
            end

           
        end
    end

end

end # module
