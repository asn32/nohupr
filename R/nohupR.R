run_nohup <- function(file,outfile_name){
  outfile_name <- paste0(dirname(file),'/',outfile_name,'.out')
  nohup_command <- paste0('nohup Rscript ',file,' > ',outfile_name,' 2>&1' )
  resp <- system(nohup_command,wait = F)
  return(list(nohup_command,outfile_name,resp))
}


dispatch_job <- function(){
  ## Prompt for out-file name
  out_name <- rstudioapi::showPrompt(title = 'Please name an outfile',message = 'outfile name')
  file <- as.character(rstudioapi::getSourceEditorContext()$path)

  res <- run_nohup(file = file,outfile_name = out_name)
  Sys.sleep(2)
  out_file <- try(read.delim(file = res[[2]],header = F,sep = '\n',as.is = 1),silent = T)
  if(any(grepl('Execution halted',c(out_file)[[1]]))){
    rstudioapi::showDialog(title = 'Job Failed',message = 'Oops',url = c(out_file)[[1]])
  }
  else{
    rstudioapi::showDialog(title = 'Job Launched',message = 'Job launched sucessfully',url ='Yay' )
  }
}

kill_jobs <- function(){
  file <- as.character(rstudioapi::getSourceEditorContext()$path)
  kill_command <- as.character(paste0("kill $(ps -aux | sort -k1r | awk '$14==\"--file=",file,"\"{print $2}')"))
  system(kill_command)
  rstudioapi::showDialog(title = 'Job Killed',message = 'Nice!',url = 'Job is kill')
}
