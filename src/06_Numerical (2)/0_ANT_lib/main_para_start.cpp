/* 
 * File:   main.cpp
 * Author: aeroware
 *
 * Created on 29. September 2010, 21:40
 */

#include <cstdlib>
#include <pthread.h>
#include <sched.h>
#include <semaphore.h>
#include <string.h>
#include <iostream>



using namespace std;

/*
 * 
 */

#define MAXTHREADS 18

typedef struct _threadparam
{
    int solver;
    int ant;
}THREADPARAM;

void *thread(void *params)
{
    int solver, ant, rval,i;
    char cdStr[20];

    solver=((THREADPARAM*)params)->solver;
    ant=((THREADPARAM*)params)->ant;

    sprintf(cdStr,"A%i/",ant);

    sleep(ant);

    if(ant >1)
    {
        chdir("..");
    }
    
        rval=chdir(cdStr);
    
    
    
    if(rval)
    {
        cout << "Cannot change to Folder " << cdStr << endl;
        return NULL;
    }
    
    switch(solver)
    {
        case 1:     // asap
            cout << "Calling ASAP for antenna " << ant << endl;
            rval=system("asap2d.bin");

            if(!rval)
                cout << "Antenna " << ant << " finished" << endl;
            else
                cout << "Antenna " << ant << " failed" << endl;

            break;
        case 2:     // concept 
            cout << "Calling concept.be for antenna " << ant << endl;
            rval=system("concept.be");
            if(!rval)
                cout << "Antenna " << ant << " finished" << endl;
            else
                cout << "Antenna " << ant << " failed" << endl;

            break;
        case 3:     // nec 2
            cout << "Calling NEC2 for antenna " << ant << endl;
            rval=system("nec2++ -inecin.dat -onecout.dat");
            if(!rval)
                cout << "Antenna " << ant << " finished" << endl;
            else
                cout << "Antenna " << ant << " failed" << endl;

            break;

    }

    return NULL;
}

int main(int argc, char** argv)
{
    int nAnts, solver;
    int i, rval;

    pthread_t tid[MAXTHREADS];
    THREADPARAM param[MAXTHREADS];

    if(argc<2)
        return 1;

    solver=atoi(argv[1]);
    nAnts=atoi(argv[2]);

    if(nAnts>MAXTHREADS)
    {
        cout << "Too many threads required" << endl;
        return 1;
    }
    
    cout << nAnts << " Antennas" << endl;
   

    for(i=1;i<=nAnts;i++)
    {
        param[i].ant=i;
        param[i].solver=solver;

        rval=pthread_create(&tid[i],NULL, thread, &param[i]);

        if(rval)
            return 1;
    }

    for(i=1;i<=nAnts;i++)
    {
        rval=pthread_join(tid[i],NULL);

        if(rval)
            return 1;
    }

    return 0;
}

