//File: bestAutoNim.c

int main(void)
{
	int n = 0, i, a, m, b;
	/*
	n is number you're adding to
	i is your iterator which keeps track of who's turn it is
	a is for storing the number you're going to add to n
	m is the max number you can add
	b is the big number to avoid
	*/
	
	srand(time(NULL));
	
	//gets the value to be avoided from the user.
	printf("The number you're avoiding is: ");
	scanf("%d", &b);
	
	//gets the max value which can be added to the total from the user
	printf("You're guessing range is between 1 to: ");
	scanf("%d", &m);
	
	printf("\nDon't let the number reach %d or greater on your turn!\n", b);
	
	//this loop will keep track of who's turn it is
	//and will run until the game is over
	for(i = 0; n<b; i++)
	{
		//Asks the player to add a number to the total (n) from 1 to the max value you can add (m)
		printf("Player %d, you're currently at %d, add a number between 1 - %d: ",(i%2) + 1, n, m);
		
		//if player 2's turn...
		if((i%2) + 1 == 2)
		{
			//run this funtion which returns the best possible move form the computer
			//b-n = distance from losing (d) (ex: avoid 13, you're at 5.  d = 13 - 5 = 8)
			a = nimMove(b-n,m);
			
			//print the input (a) on the screen so it looks the same as when the human inputs their input
			printf("%d\n",a);
		}
		//if player 1's turn...
		else
		{
			//get a input from the user (a)
			scanf("%d",&a);
			
			//if the input (a) isn't valid, keeping asking him until the input (a) is valid
			while(a < 1 || a > m)
			{
				printf("Haha, nice try: ");
				scanf("%d",&a);
			}
		}
		
		//add the input (a) to the total (n)
		n += a;
		printf("\n\n");
	}
	
	//Annonce which player one
	printf("Player %d wins!", (i%2) + 1);
	
	//end the program
	return 0;
}

//returns the best possible move for the computer given the distance from losing (d=b-n)
int nimMove(int d, int m)
{
	int i, output;
		//the default for the computer is to output a random move if it knows it has no good moves.
		if(d>m)
		{
			output = rand()%m + 1;
		}
		else
		{
			output = rand()%d + 1;
		}
		
		//This array is resposible to store all the point values for
		//all the distances so that the program doesn't calculate it more than once
		
		//To avoid the array having random values by default,
		//we set every value in the array to -1
		int nMP[d];
		for(i = 0;i<d;i++)
		{
			nMP[i]=-1;
		}
		
		//for all possible future game states which can be reached after your turn given from your d & m value..
		//(ex: avoid d = 11, m = 3, check when d = 10, 9, & 8)
		for(i = 1; (m-i)>=0&&(d-i)>=0; i++)
		{
			//check which one leads to a losing game state and if one does,
			//do the move which leads to that losing game state
			//(ex: when d = 9, that player is going to lose in a perfect game so do the move which makes that happen)
			if(nimMovePoint(d-i,m,nMP) == 0) output = i;
		}
		
	//return best move
	return output;
	
}

//returns if a player can win or not in a perfect game depending on d and m
int nimMovePoint(int d, int m, int * nMP)
{
	//if this value has already been calulated and stored...
	if(nMP[d]!=-1)
	{
		//use the value which has already been calculated for the result of the funtion
		//to drasticlly cut down on processing time / get a lower the Big O time
		return nMP[d];
	}
	
	//for output, 1 = win & 0 = lose
	int output = 0;

	//if the distance is 0, you're opponent must have added to a distance of 0 and lost, meaning you win.
	if(d == 0)
	{
		output = 1;
	}
	else
	{
		
		int i;
		//for all possible future game states which can be reached after your turn given from your d & m value..
		//(ex: avoid d = 2, m = 3, check when d = 1 & 0)
		for(i = 1; (m-i)>=0&&(d-i)>=0; i++)
		{
				//if this game state has already been solved and stored...
				if(nMP[d-i]!=-1)
				{
					//instead of re-solving it, just use the value which we solved eariler.
					if(nMP[d-i] == 0)
					{
						output = 1;
					}
				} else {
				
				//check which one leads to a losing game state and if one does,
				//do the move which leads to that losing game state
				//(ex: when d = 1, that player is going to lose so do the move which makes that happen)
				if(nimMovePoint(d-i,m,nMP) == 0) output = 1;
				
			}
		}
	}
	
	//when you find the result of to this funtion under these inputs,
	//store that value into the array (nMP) through this pointer
	nMP[d] = output;
	
	//return either a win or a lose.
	return output;
	
}
