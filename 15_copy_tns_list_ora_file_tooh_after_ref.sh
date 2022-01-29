#!/bin/bash

targoh=/c08/db/tech_st/12.1.0/dbs
targlistloc=/c08/db/tech_st/12.1.0/network/admin
clnloc=/u02/CLONE_HOME/ADMS08

ls -ld $targoh
ls -ld $targlistloc

cd $targoh
cp $clnloc/initADMS08.ora .
cp $clnloc/spfileADMS08.ora .

cd $targlistloc
cp $clnloc/*.ora .

ls -ltr $targoh
ls -ltr $targlistloc
