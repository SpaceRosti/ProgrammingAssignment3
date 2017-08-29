downloadzipfile<-function(){ # download the files and check if they already exist
    dlMethod <- "curl" # sets default for OSX / Linux
    if(substr(Sys.getenv("OS"),1,7) == "Windows"){
        dlMethod <- "wininet" # set method for windows
    }
    
    if(!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")){
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                      destfile = "getdata_projectfiles_UCI HAR Dataset.zip",
                      method=dlMethod,
                      mode = "wb")
    }
    
    unzip(zipfile = "getdata_projectfiles_UCI HAR Dataset.zip")
    
}

mergedata<-function(){ # merge the data sets and return it
    xtrain<-read.table("UCI HAR Dataset/train/X_train.txt")
    ytrain<-read.table("UCI HAR Dataset/train/y_train.txt")
    subtrain<-read.table("UCI HAR Dataset/train/subject_train.txt")
    trainmerged<-cbind(subtrain,ytrain,xtrain)
    names(trainmerged)[1]<-"subject"
    names(trainmerged)[2]<-"activity"
    
    xtest<-read.table("UCI HAR Dataset/test/X_test.txt")
    ytest<-read.table("UCI HAR Dataset/test/y_test.txt")
    subtest<-read.table("UCI HAR Dataset/test/subject_test.txt")
    testmerged<-cbind(subtest,ytest,xtest)
    names(testmerged)[1]<-"subject"
    names(testmerged)[2]<-"activity"
    
    totalmerged<-rbind(trainmerged,testmerged)
    totalmerged
}

takemeanstd<-function(x=data.frame()){ # extracts the measurements on the mean and standard deviation.
    features<-read.table("UCI HAR Dataset/features.txt")
    x<-x[,grep("\\bmean()\\b|std()",features[,2])]
    x
}

usenames<-function(ok=data.frame()){ # change the activity number by his name
    activity<-read.table("UCI HAR Dataset/activity_labels.txt")
    position=0
    for(i in ok[,2]){
        position<-position+1
        ok[position,2]<-as.character(activity[i,2])
    }
    ok
}

uselabel<-function(x=data.frame()){ # label the data set with descriptive variable names. 
    features<-read.table("UCI HAR Dataset/features.txt")
    labels<-grep("\\bmean()\\b|std()",features[,2],value=TRUE)
    position<-0
    for(i in names(x)){
        position<- position + 1
        if(position>=3){
            names(x)[position]<-labels[position]
        }
    }
    x
}

createaverage<-function(x=data.frame()){ #  create a data set with the average of each variable for each activity and each subject.
    newset<-data.frame()
    vectsubj<-NULL
    vectact<-NULL
    for(i in unique(x$subject)){
        for(j in unique(x$activity)){
            newset<-rbind(newset,apply(filter(x,subject == i & activity == j)[,3:length(x)],2,mean))
            vectsubj<-c(vectsubj,i)
            vectact<-c(vectact,j)
        }
    }
    newset<-cbind(vectsubj,vectact,newset)
    names(newset)<-names(x)
    arrange(newset,subject)
    newset
}

tidydata<-function(){ # combine all the previous function and return a tidy data set
    downloadzipfile()
    createaverage(uselabel(usenames(takemeanstd(mergedata()))))
}