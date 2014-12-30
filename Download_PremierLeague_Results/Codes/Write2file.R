write2file <- function(df, name, ...){
    
    if (file.exists("../Sample_Outputs")) {
        print("Warning! ../Sample_Outputs exists.")
    }
    else {
        dir.create("../Sample_Outputs")
    }
    
    df_name <- deparse(substitute(df))
    output_name <- deparse(substitute(name))
    
    file_name <- paste("../Sample_Outputs/", output_name, "_", format(Sys.time(), "%y-%m-%d_%H%M"), 
                       '.csv', sep = "")
    print(paste("Writing", df_name , "to", file_name))
    write.table(df, file_name, ...)
    print("done")
    
}

