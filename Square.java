//
// Square class has variables and functions that pertain to
// each square on a Sudoku board (1 of 81 pieces on the board)
//
// boxNumber represents the box number as labeled in Board.java
//
// the boardCol/Row variables represent the squares label in a
// traditional 2D array
//
// originalSquare represents values that cannot be manipulated
//

import javax.swing.*;
import java.util.ArrayList;


public class Square {

    private int value;
    private JButton button;
    private int boxNumber;
    private int boardRow;
    private int boardCol;

    private ArrayList<Integer> candidateList;



    public Square(int newValue) {

        //
        // First determine if value for square is valid
        //
        // 0 represents clear button
        //

        if (newValue < 0 || newValue > 9) {
            System.out.println("Invalid value for square");
        } else {
            button = new JButton("");
            value = newValue;

            boxNumber = -1;
            boardCol = -1;
            boardRow = -1;

            candidateList = new ArrayList<>();

            for (int i = 1 ; i < 10 ; ++i) {
                candidateList.add(i);
            }
        }
    }

    //
    // Sets a new value and changes display text for button
    //

    public void setValue(int newValue) {
        if (newValue < 0 || newValue > 10) {
            System.out.println("Invalid value for square");
        } else {
            value = newValue;

            if (newValue == 0) {
                button.setText("");
            } else if (newValue == 10) {
                // Print array list
            } else {
                button.setText(String.valueOf(value));
            }


        }

    }

    //
    // Getter for value
    //

    public int getValue() {
        return value;
    }

    //
    // Getter for button
    //

    public JButton getButton() {
        return button;
    }

    public void setSquareImmutable() {
        button.setEnabled(false);
    }

    //
    // Setter/getter for box number
    //

    public void setBoxNumber(int newBoxNumber) {
        boxNumber = newBoxNumber;
    }

    public int getBoxNumber() {
        return  boxNumber;
    }

    //
    // Setter/getter for boardRow/Col
    //

    public void setBoardRow(int newBoardRow) {
        boardRow = newBoardRow;
    }

    public int getBoardRow() {
        return boardRow;
    }

    public void setBoardCol(int newBoardCol) {
        boardCol = newBoardCol;
    }

    public int getBoardCol() {
        return boardCol;
    }

    //
    // Add/Remove to candidateList
    //

    public void addToList(int newCandidate) {
        //
        // If the list doesn't have the current val, add it
        //
        if (!candidateList.contains(newCandidate)) {
            candidateList.add(newCandidate);
        }
    }

    public void removeFromList(int containedInt) {
        if (candidateList.contains(containedInt)) {
            Integer object = containedInt;
            candidateList.remove(object);
        }
    }

    //
    // Getter
    //

    public ArrayList<Integer> getCandidateList() {
        return candidateList;
    }

    public void initCandidateList()
    {

        for (int i = 1 ; i < 10 ; ++i) {
            if(!candidateList.contains(i)) {
                candidateList.add(i);
            }
        }
    }

    public void canidateListDifferencing(ArrayList<Integer> potential)
    {

        for(Integer c : candidateList)
        {
            if(potential.contains(c))
            {
                potential.remove(c);
            }
        }


    }
}
