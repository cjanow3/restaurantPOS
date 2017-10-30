import javax.swing.*;

public class SideButton {

    private JButton b;
    private int value;

    //
    // Values 0..9 take on value as text
    // Value 10 is the clear button
    //
    public SideButton(int newValue) {

        if (newValue == 0) {
            b = new JButton("X");
            value = newValue;

        } else if (newValue == 10) {
            b = new JButton("?");
            value = newValue;
        } else {
            String text = String.valueOf(newValue);
            b = new JButton(text);
            value = newValue;
        }

    }

    //
    // Getters for button and value
    //

    public JButton getB() {
        return b;
    }

    public int getValue() {
        return value;
    }
}
