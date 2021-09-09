
import random

board = {'7':' ','8':' ','9':' ',
         '4':' ','5':' ','6':' ',
         '1':' ','2':' ','3':' '}
Opp = 'O'
turn = 'X'

botList = '123456789'
counter = None
def checkWin():
    global counter
    counter = 0

    if board['7'] == board['8'] == board['9'] != ' ':
        print('Well done, ' + board['7'] +' has won!')
        counter += 1
        return counter
    elif board['4'] == board['5'] == board['6'] != ' ':
        print('Well done, ' + board['4'] +' has won!')
        counter += 1
        return counter

    elif board['1'] == board['2'] == board['3'] != ' ':
        print('Well done, ' + board['1'] +' has won!')
        counter += 1
        return counter

    elif board['1'] == board['4'] == board['7'] != ' ':
        print('Well done, ' + board['1'] +' has won!')
        counter += 1
        return counter

    elif board['2'] == board['5'] == board['8'] != ' ':
        print('Well done, ' + board['2'] +' has won!')
        counter += 1
        return counter

    elif board['3'] == board['6'] == board['9'] != ' ':
        print('Well done, ' + board['3'] +' has won!')
        counter += 1
        return counter

    elif board['1'] == board['5'] == board['9'] != ' ':
        print('Well done, ' + board['1'] +' has won!')
        counter += 1
        return counter

    elif board['3'] == board['5'] == board['7'] != ' ':
        print('Well done, ' + board['3'] +' has won!')
        counter += 1
        return counter






def printBoard():
    print('\n')
    print('|' + board['7'] + '|' + board['8'] + '|' + board['9'] + '|')
    print('+-+-+-+')
    print('|' + board['4'] + '|' + board['5'] + '|' + board['6'] + '|')
    print('+-+-+-+')
    print('|' + board['1'] + '|' + board['2'] + '|' + board['3'] + '|')

def botFunc():
    ok = 0
    while ok == 0:
        bot = random.choice(botList)
        if board[bot] == ' ':
            board[bot] = Opp
            ok = ok + 1

def mainG():
    print("Game of TicTacToe. Grid goes left to right, bottom left being 1.")
    while counter != 1:
            userGo = input('Where would you like to go?')
            if board[userGo] == ' ':
                board[userGo] = turn
                printBoard()
                botFunc()
                checkWin()
            else:
                print('Oops! That spot has already been taken!')
            printBoard()

if __name__ == '__main__':
    printBoard()
    mainG()
