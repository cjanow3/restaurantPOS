//
// Board class has 81 squares, and is separated into 9 boxes
//

/*

    The board is set up with the boxes being equal to
    the first index in gameBoard[][], and the second
    index represents the index in that box.

     ___________  __________ __________
    |           |           |          |
    |  box = 0  |   box = 1 |  box = 2 |
    | - - - - - - - - - - - - - - - - -
    |  box = 3  |   box = 4 |  box = 5 |
    | - - - - - - - - - - - - - - - - -
    |  box = 6  |   box = 7 |  box = 8 |
     ___________  __________ __________


 */


import java.util.ArrayList;

public class Board {

    private Square[][] gameBoard;
    private int editingNum;
    private int spacesLeft;
    private ArrayList<ArrayList<SquarePair>> rowPairs;
    private ArrayList<ArrayList<SquarePair>> colPairs;

    private boolean toggleEnabled;

    public Board() {
        gameBoard = new Square[9][9];
        spacesLeft = 81;
        rowPairs = new ArrayList<>();
        colPairs = new ArrayList<>();
        toggleEnabled = false;

        for (int i = 0 ; i < 9; ++i) {
            for (int j = 0 ; j < 9 ; ++j) {
                Square s = new Square(0);
                gameBoard[i][j] = s;
            }
        }

        for (int i = 0 ; i < 9; ++i) {
            for (int j = 0; j < 9; ++j) {

                int box;
                int row = i;
                int col = j;

                if (0 <= row && row < 3) {

                    if (0 <= col && col < 3) {
                        box = 0;
                    } else if (3 <= col && col < 6) {
                        box = 1;
                    } else {
                        box = 2;
                    }

                } else if (3 <= row && row < 6) {
                    if (0 <= col && col < 3) {
                        box = 3;
                    } else if (3 <= col && col < 6) {
                        box = 4;
                    } else {
                        box = 5;
                    }
                } else {
                    if (0 <= col && col < 3) {
                        box = 6;
                    } else if (3 <= col && col < 6) {
                        box = 7;
                    } else {
                        box = 8;
                    }
                }


                row %= 3;
                col %= 3;

                int index;


                index = (row * 3) + col;

                gameBoard[box][index].setBoardRow(i);
                gameBoard[box][index].setBoardCol(j);
                gameBoard[box][index].setBoxNumber(box);

            }
        }

        //
        // Populate the ArrayList of SquarePairs
        //


        for (int i = 0 ; i < 9 ; ++i) {
            ArrayList<SquarePair> s = new ArrayList<>();

            for (int j = 0 ; j < 9; ++j) {
                int index = (3 * (i%3)) + (j%3);
                int box   = (j / 3) + (3 * (i/3));

                SquarePair sp = new SquarePair(box,index);
                s.add(sp);
            }
            rowPairs.add(s);
        }

        for (int i = 0 ; i < 9 ; ++i) {
            ArrayList<SquarePair> s = new ArrayList<>();

            for (int j = 0 ; j < 9; ++j) {
                SquarePair sp = new SquarePair(rowPairs.get(j).get(i).getBox(),rowPairs.get(j).get(i).getIndex());
                s.add(sp);
            }
            colPairs.add(s);

        }

        editingNum = 0;
    } //end Board Constructor

    public Square getSquare(int box,int index) {

        if (box < 0 || box > 9 || index < 0 || index > 9) {
            System.out.println("Invalid index"); return null;
        } else {
            return gameBoard[box][index];
        }
    }

    public void setEditingNum(int newEditingNum) {
        if (newEditingNum < 0 || newEditingNum > 10) {
            System.out.println("Invalid number for editing number");
        } else {
            editingNum = newEditingNum;
        }
    }

    public int getEditingNum() {
        return editingNum;
    }

    public boolean checkForValidMove(int row, int col, int box, int val) {

        //
        // Go through each row, col, and box to determine if
        // the value inputted is unique relative to each case
        //


        //
        // If value that comes in == 0,
        // then it is attempting to clear the
        // square
        //

        if (val == 0) {
            return true;
        }

        //
        // Determine first if they value exists in either the row,
        // column, or box. Then check to see if it is in all spots,
        // because that means it is comparing it to itself
        //

        for (int i = 0 ; i < 9 ; ++i) {
            for (int j = 0 ; j < 9 ; ++j) {

                Square s = gameBoard[i][j];

                if (s.getValue() == val && (s.getBoardRow() == row || s.getBoardCol() == col || s.getBoxNumber() == box))
                {
                    if (!(s.getBoardRow() == row && s.getBoardCol() == col && s.getBoxNumber() == box)) {
                        return false;
                    }

                }

            }
        }

        return true;
    }

    //
    // Decrease/Increase spaces left,
    // when == 0 check for other win conditions
    //

    public void decreaseSpacesLeft() {
        spacesLeft -= 1;
    }

    public void increaseSpacesLeft() {
        spacesLeft += 1;
    }

    public int getSpacesLeft() {
        return  spacesLeft;
    }

    public ArrayList<ArrayList<SquarePair>> getRowPairs() {
        return rowPairs;
    }

    public ArrayList<ArrayList<SquarePair>> getColPairs() {
        return colPairs;
    }

    public void updateCandidateList()
    {
        for(int box = 0; box < 9; ++box) {
            for (int index = 0; index < 9; ++index) {
                gameBoard[box][index].initCandidateList();
            }
        }

        for(int box = 0; box < 9; ++box) {
            for(int index = 0; index < 9; ++index)
            {

                Square S = gameBoard[box][index];
                int val = S.getValue();
                int currentRow = S.getBoardRow();
                int currentCol = S.getBoardCol();
                for(int i=0; i<9; i++)
                {
                    int colBox = getColPairs().get(currentCol).get(i).getBox();
                    int colIndex =  getColPairs().get(currentCol).get(i).getIndex();
                    int rowBox =  getRowPairs().get(currentRow).get(i).getBox();
                    int rowIndex = getRowPairs().get(currentRow).get(i).getIndex();

                    if(colBox != box || colIndex != index)
                    {

                        this.getSquare(colBox,colIndex).removeFromList(val);

                    }

                    if(rowBox != box || rowIndex != index)
                    {

                        getSquare(rowBox, rowIndex).removeFromList(val);
                    }
                    if(i != index)
                    {
                        getSquare(box, i).removeFromList(val);
                    }

                }
              }
            }
        }




    public boolean toggleIsEnabled() {
        return toggleEnabled;
    }

    public void switchToggle() {
        if (toggleEnabled) {
            toggleEnabled = false;
        } else {
            toggleEnabled = true;
        }
    }



    public boolean singleSolve()
    {
        for(int box = 0; box < 9; ++box) {
            for (int index = 0; index < 9; ++index) {
                Square S =gameBoard[box][index];
                if(S.getCandidateList().size() == 1 && S.getValue() == 0) //to solve for single candidate list must have one candidate and the square must be blank (value = 0)
                {
                    S.setValue(S.getCandidateList().get(0));
                    updateCandidateList();
                    return true;
                }
            }
        }
        return false;
    }

    public boolean hiddenSingleSolve()
    {


        for(int box = 0; box < 9; ++box) {
            for (int index = 0; index < 9; ++index) {

                Square s = gameBoard[box][index];

                if(s.getValue() != 0) //we only try to search for values for a square if it is blank
                {
                    continue;
                }
                ArrayList<Integer> potentialCol = (ArrayList<Integer>) gameBoard[box][index].getCandidateList().clone();
                ArrayList<Integer> potentialRow = (ArrayList<Integer>) gameBoard[box][index].getCandidateList().clone();
                ArrayList<Integer> potentialBox = (ArrayList<Integer>) gameBoard[box][index].getCandidateList().clone();
                ArrayList<SquarePair> rowList = rowPairs.get(s.getBoardRow());
                ArrayList<SquarePair> colList = colPairs.get(s.getBoardCol());


                for(int i = 0; i<9; ++i)
                {
                    SquarePair colPair = colList.get(i);
                    SquarePair rowPair = rowList.get(i);

                    int colBox = colPair.getBox();
                    int colIndex = colPair.getIndex();
                    int rowBox = rowPair.getBox();
                    int rowIndex = rowPair.getIndex();
                    int boxBox = box;
                    int boxIndex = i;

                    if(colBox != box || colIndex != index)
                    {
                        Square comparisonSquare = gameBoard[colBox][colIndex];
                        comparisonSquare.canidateListDifferencing(potentialCol);
                    }

                    if(rowBox != box || rowIndex != index)
                    {
                        Square comparisonSquare = gameBoard[rowBox][rowIndex];
                        comparisonSquare.canidateListDifferencing(potentialRow);
                    }
                    if(boxBox != box || boxIndex != index)
                    {
                        Square comparisonSquare = gameBoard[boxBox][boxIndex];
                        comparisonSquare.canidateListDifferencing(potentialBox);
                    }






                }
                if(potentialBox.size() == 1)
                {
                    s.setValue(potentialBox.get(0));
                    updateCandidateList();
                    return true;
                }

                if(potentialCol.size() == 1)
                {
                    s.setValue(potentialCol.get(0));
                    updateCandidateList();
                    return true;
                }
                if(potentialRow.size() == 1)
                {
                    s.setValue(potentialRow.get(0));
                    updateCandidateList();
                    return true;
                }




            }

        }



        return false;
    }

    public boolean nakedPairsSolve()
    {

        for(int rowColBoxIter = 0; rowColBoxIter < 9; rowColBoxIter++) {

            ArrayList<ArrayList<Integer>> potentialColPairs = new ArrayList<>();
            ArrayList<ArrayList<Integer>> potentialRowPairs = new ArrayList<>();
            ArrayList<ArrayList<Integer>> potentialBoxPairs = new ArrayList<>();

            ArrayList<SquarePair> rowList = rowPairs.get(rowColBoxIter);
            ArrayList<SquarePair> colList = colPairs.get(rowColBoxIter);


            for (int i = 0; i < 9; ++i) {
                SquarePair colPair = colList.get(i);
                SquarePair rowPair = rowList.get(i);

                int colBox = colPair.getBox();
                int colIndex = colPair.getIndex();
                int rowBox = rowPair.getBox();
                int rowIndex = rowPair.getIndex();
                int boxBox = rowColBoxIter;
                int boxIndex = i;

                if (true) {
                    Square comparisonSquare = gameBoard[colBox][colIndex];
                    if (comparisonSquare.getCandidateList().size() == 2) {
                        potentialColPairs.add((ArrayList<Integer>) comparisonSquare.getCandidateList().clone());
                    }
                }

                if (true) {
                    Square comparisonSquare = gameBoard[rowBox][rowIndex];
                    if (comparisonSquare.getCandidateList().size() == 2) {
                        potentialColPairs.add((ArrayList<Integer>) comparisonSquare.getCandidateList().clone());
                    }
                }
                if (true) {
                    Square comparisonSquare = gameBoard[boxBox][boxIndex];
                    if (comparisonSquare.getCandidateList().size() == 2) {
                        potentialColPairs.add((ArrayList<Integer>) comparisonSquare.getCandidateList().clone());
                    }
                }


            }//finish singular row,col,box scan

            if (potentialColPairs.size() > 1) {
                ArrayList<ArrayList<Integer>> confirmedPairsList = nakedPairsHelper(potentialColPairs);

                for (int p = 0; p < confirmedPairsList.size(); ++p) {

                    for (int i = 0; i < 9; ++i) {
                        SquarePair colPair = colList.get(i);
                        int colBox = colPair.getBox();
                        int colIndex = colPair.getIndex();
                        Square r = gameBoard[colBox][colIndex];

                        if (r.getCandidateList().size() == 3 && r.getCandidateList().contains(confirmedPairsList.get(p).get(0)) && r.getCandidateList().contains(confirmedPairsList.get(p).get(1))) {
                            for (int j = 0; j < 3; ++j) {
                                if (!confirmedPairsList.contains(r.getCandidateList().get(j))) {
                                    r.setValue(r.getCandidateList().get(j));
                                    updateCandidateList();
                                    return true;
                                }
                            }
                        }


                    }


                }
            }
            if (potentialRowPairs.size() > 1) {
                ArrayList<ArrayList<Integer>> confirmedPairsList = nakedPairsHelper(potentialRowPairs);

                for (int p = 0; p < confirmedPairsList.size(); ++p) {

                    for (int i = 0; i < 9; ++i) {
                        SquarePair rowPair = rowList.get(i);
                        int rowBox = rowPair.getBox();
                        int rowIndex = rowPair.getIndex();
                        Square r = gameBoard[rowBox][rowIndex];

                        if (r.getCandidateList().size() == 3 && r.getCandidateList().contains(confirmedPairsList.get(p).get(0)) && r.getCandidateList().contains(confirmedPairsList.get(p).get(1))) {
                            for (int j = 0; j < 3; ++j) {
                                if (!confirmedPairsList.contains(r.getCandidateList().get(j))) {
                                    r.setValue(r.getCandidateList().get(j));
                                    updateCandidateList();
                                    return true;
                                }
                            }
                        }


                    }


                }
            }
            if (potentialBoxPairs.size() > 1) {
                ArrayList<ArrayList<Integer>> confirmedPairsList = nakedPairsHelper(potentialBoxPairs);

                for (int p = 0; p < confirmedPairsList.size(); ++p) {

                    for (int i = 0; i < 9; ++i) {

                        int boxBox = rowColBoxIter;
                        int boxIndex = i;
                        Square r = gameBoard[boxBox][boxIndex];

                        if (r.getCandidateList().size() == 3 && r.getCandidateList().contains(confirmedPairsList.get(p).get(0)) && r.getCandidateList().contains(confirmedPairsList.get(p).get(1))) {
                            for (int j = 0; j < 3; ++j) {
                                if (!confirmedPairsList.contains(r.getCandidateList().get(j))) {
                                    r.setValue(r.getCandidateList().get(j));
                                    updateCandidateList();
                                    return true;
                                }
                            }
                        }


                    }


                }
            }

        }



        return false;
    }






    private ArrayList<ArrayList<Integer>>  nakedPairsHelper( ArrayList<ArrayList<Integer>> potentialPairs)
    {


        ArrayList<ArrayList<Integer>> result = new ArrayList<>();
        for(int i = 0; i < potentialPairs.size() -1 ; ++i)
        {
            for(int j = i+1; j < potentialPairs.size(); ++j)
            {

                ArrayList<Integer> a = potentialPairs.get(i);
                ArrayList<Integer> b = potentialPairs.get(j);

                if(a.get(0) == b.get(0) && a.get(1) == b.get(1))
                {
                    result.add((ArrayList<Integer>)a.clone());
                }




            }

        }
        return result;
    }



    public boolean lockedCandidateOne()
    {

        for ( int box = 0; box < 9; ++box)
        {

            //make potential candidates in row;

            //make potential candidates in col;


            //subtract from from or collumn... left overs... remove from cadidate list outside of box for corresponding row/col

            ArrayList<Integer> potentialRow = new ArrayList<>();
            ArrayList<Integer> potentialCol = new ArrayList<>();


            for(int row = 0; row < 3; ++row)
            {
                int rowOffset = row * 3;

                for(int i = 0; i < 3; ++i) {
                    //row search
                    Square a = gameBoard[box][rowOffset+i];


                    for (Integer candidate : a.getCandidateList()) {
                        if (!potentialRow.contains(candidate)) {
                            potentialRow.add(candidate);
                        }
                    }

                    //Col search

                    Square b = gameBoard[box][(i*3) + row];

                    for (Integer candidate : b.getCandidateList()) {
                        if (!potentialCol.contains(candidate)) {
                            potentialCol.add(candidate);
                        }
                    }




                }


                for (int i = 3; i<9; ++i)
                {   //row removal
                    Square a = gameBoard[box][(rowOffset + i)%9];
                    for(Integer candidate : a.getCandidateList() )
                    {
                        if (potentialRow.contains(candidate)) {
                            potentialRow.remove(candidate);
                        }
                    }

                }

                for (int i = 0; i<3; ++i)
                {
                    Square a = gameBoard[box][((i*3) + row + 1)%9];
                    Square b = gameBoard[box][((i*3) + row + 2) %9];

                    for(Integer candidate : a.getCandidateList() )
                    {
                        if (potentialRow.contains(candidate)) {
                            potentialRow.remove(candidate);
                        }
                    }
                    for(Integer candidate : b.getCandidateList() )
                    {
                        if (potentialCol.contains(candidate)) {
                            potentialCol.remove(candidate);
                        }
                    }


                }




                if(potentialRow.size() > 0)
                {
                    int gameRow = gameBoard[box][rowOffset].getBoardRow();
                    ArrayList<SquarePair> gameRowList = rowPairs.get(gameRow);

                    for(SquarePair S : gameRowList)
                    {

                        if(S.getBox() != box)
                        {
                            ArrayList<Integer> clonedSCandidateList = (ArrayList<Integer>) gameBoard[S.getBox()][S.getIndex()].getCandidateList().clone();
                            for(Integer C : clonedSCandidateList)
                            {
                                if(potentialRow.contains(C))
                                {
                                    clonedSCandidateList.remove(C);
                                }
                            }

                            if(clonedSCandidateList.size() == 1)
                            {
                                gameBoard[S.getBox()][S.getIndex()].setValue(clonedSCandidateList.get(0));
                                return true;
                            }

                        }

                    }



                }


                if(potentialCol.size() > 0)
                {
                    int gameCol = gameBoard[box][row].getBoardRow();
                    ArrayList<SquarePair> gameColList = colPairs.get(gameCol);

                    for(SquarePair S : gameColList)
                    {

                        if(S.getBox() != box)
                        {
                            ArrayList<Integer> clonedSCandidateList = (ArrayList<Integer>) gameBoard[S.getBox()][S.getIndex()].getCandidateList().clone();
                            for(Integer C : clonedSCandidateList)
                            {
                                if(potentialCol.contains(C))
                                {
                                    clonedSCandidateList.remove(C);
                                }
                            }

                            if(clonedSCandidateList.size() == 1)
                            {
                                gameBoard[S.getBox()][S.getIndex()].setValue(clonedSCandidateList.get(0));
                                return true;
                            }

                        }

                    }



                }

            }









        }
        return false;


    }

    public boolean lockedCandidateTwo()
    {

        //row

        for(int searchRow = 0; searchRow <9; ++searchRow)
        {
            ArrayList<Integer> potentialCandidates = new ArrayList<>();
            ArrayList<Integer> notPotentialCandidates = new ArrayList<>();
            ArrayList<SquarePair> rowList = rowPairs.get(searchRow);

            for(int box = rowList.get(0).getBox(); box < (rowList.get(0).getBox() +3); ++box )
            {

                for (int i = 0; i < 9; ++i) {

                    SquarePair S = rowList.get(i);

                    if (S.getBox() == box) {
                        for (Integer C : gameBoard[S.getBox()][S.getIndex()].getCandidateList()) {
                            if (!potentialCandidates.contains(C)) {
                                potentialCandidates.add(C);
                            }
                        }
                    } else {
                        for (Integer C : gameBoard[S.getBox()][S.getIndex()].getCandidateList()) {
                            if (!notPotentialCandidates.contains(C)) {
                                notPotentialCandidates.add(C);
                            }
                        }

                    }


                }

                for (Integer C : notPotentialCandidates)
                {
                    if (potentialCandidates.contains(C))
                    {
                        potentialCandidates.remove(C);
                    }
                }

                if (potentialCandidates.size() > 1)
                {
                    ArrayList<Integer> boxesToCheck = new ArrayList<>();
                    for (int i = 0; i < 9; i++)
                    {
                        if (!boxesToCheck.contains(rowList.get(i).getBox()) && rowList.get(i).getBox() != box)
                        {
                            boxesToCheck.add(rowList.get(i).getBox());
                        }


                    }

                    for(Integer b: boxesToCheck)
                    {
                        for(int i = 0; i < 9 ; ++i)
                        {
                            Square S = gameBoard[b][i];
                            ArrayList<Integer> clonedSCandidateList = (ArrayList<Integer>) S.getCandidateList().clone();
                            for(Integer P : potentialCandidates)
                            {
                                if(clonedSCandidateList.contains(P))
                                {
                                    clonedSCandidateList.remove(P);
                                }

                            }
                            if(clonedSCandidateList.size() == 1)
                            {
                                S.setValue(clonedSCandidateList.get(0));
                                return true;
                            }


                        }
                    }

                }


            }


        }


        for(int searchCol= 0; searchCol <9; ++searchCol)
        {
            ArrayList<Integer> potentialCandidates = new ArrayList<>();
            ArrayList<Integer> notPotentialCandidates = new ArrayList<>();
            ArrayList<SquarePair> colList = colPairs.get(searchCol);

            for(int box = colList.get(0).getBox(); box <= (colList.get(9).getBox()); box+=3 )
            {

                for (int i = 0; i < 9; ++i) {

                    SquarePair S = colList.get(i);

                    if (S.getBox() == box) {
                        for (Integer C : gameBoard[S.getBox()][S.getIndex()].getCandidateList()) {
                            if (!potentialCandidates.contains(C)) {
                                potentialCandidates.add(C);
                            }
                        }
                    } else {
                        for (Integer C : gameBoard[S.getBox()][S.getIndex()].getCandidateList()) {
                            if (!notPotentialCandidates.contains(C)) {
                                notPotentialCandidates.add(C);
                            }
                        }

                    }


                }

                for (Integer C : notPotentialCandidates)
                {
                    if (potentialCandidates.contains(C))
                    {
                        potentialCandidates.remove(C);
                    }
                }

                if (potentialCandidates.size() > 1)
                {
                    ArrayList<Integer> boxesToCheck = new ArrayList<>();
                    for (int i = 0; i < 9; i++)
                    {
                        if (!boxesToCheck.contains(colList.get(i).getBox()) && colList.get(i).getBox() != box)
                        {
                            boxesToCheck.add(colList.get(i).getBox());
                        }


                    }

                    for(Integer b: boxesToCheck)
                    {
                        for(int i = 0; i < 9 ; ++i)
                        {
                            Square S = gameBoard[b][i];
                            ArrayList<Integer> clonedSCandidateList = (ArrayList<Integer>) S.getCandidateList().clone();
                            for(Integer P : potentialCandidates)
                            {
                                if(clonedSCandidateList.contains(P))
                                {
                                    clonedSCandidateList.remove(P);
                                }

                            }
                            if(clonedSCandidateList.size() == 1)
                            {
                                S.setValue(clonedSCandidateList.get(0));
                                updateCandidateList();

                                return true;

                            }


                        }
                    }

                }


            }


        }

        return false;
    }



} // end Board class
