/*

    Holds box number and index in that
    box to index into the game board.


 */

public class SquarePair {

    private int box;
    private int index;

    public SquarePair(int newBox, int newIndex) {
        box = newBox;
        index = newIndex;
    }

    //
    // Setters/getters
    //

    public int getBox() {
        return box;
    }

    public int getIndex() {
        return index;
    }

    public void setBox(int newBox) {
        box = newBox;
    }

    public void setIndex(int newIndex) {
        index = newIndex;
    }


}
