write2file <- function(df, name, ...){
    
    if (file.exists("data")) {
        print("Warning! /data exists.")
    }
    else {
        dir.create("data")
    }
    
    df_name <- deparse(substitute(df))
    output_name <- deparse(substitute(name))
    
    file_name <- paste("data/", output_name, "_", format(Sys.time(), "%y-%m-%d_%H%M"), 
                       '.csv', sep = "")
    print(paste("Writing", df_name , "to", file_name))
    write.table(df, file_name, ...)
    print("done")
    
}

