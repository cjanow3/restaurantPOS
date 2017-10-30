
import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import java.util.ArrayList;

public class Game {

    public static void main(String[] args) {

        //
        // Create instance of board
        //

        Board b = new Board();

        //
        // Create JFrame, menus, and panels
        //

        JFrame frame = new JFrame("Sudoku");
        frame.setSize(800,350);
        frame.setVisible(true);
        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);

        JMenuBar menuBar = new JMenuBar();

        JMenu fileMenu = new JMenu("File");
        JMenu infoMenu = new JMenu("Info");
        JMenu hintsMenu = new JMenu("Hints");

        JMenuItem howToPlay = new JMenuItem("How To Play");
        JMenuItem howToUse = new JMenuItem("How to Use This Program");
        JMenuItem about = new JMenuItem("About");

        JMenuItem load = new JMenuItem("Load");
        JMenuItem save = new JMenuItem("Save");
        JMenuItem exit = new JMenuItem("Exit");

        JMenuItem toggleValidMoves = new JMenuItem("Toggle Valid Moves : " + b.toggleIsEnabled());
        JMenuItem singles = new JMenuItem("Singles");
        JMenuItem hiddenSingles = new JMenuItem("Hidden Singles");
        JMenuItem nakedPairs = new JMenuItem("Naked Pairs");
        JMenuItem lockedCandidates = new JMenuItem("Locked Candidates");
        JMenuItem allAlgorithms = new JMenuItem("Use all hints");


        //
        // Action listener for Load function
        //
        // Load function uses JFileChooser and filters
        // user to pick from .txt file used to populate
        // sudoku board
        //

        load.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                //
                // Limit user to .txt files with JFileChooser
                //

                JFileChooser chooser = new JFileChooser();
                FileNameExtensionFilter filter = new FileNameExtensionFilter("Text Files","txt");
                chooser.setFileFilter(filter);


                //
                // Take txt file and parse it, populating the board
                //

                int returnVal = chooser.showOpenDialog(null);

                try {
                    if (returnVal == JFileChooser.APPROVE_OPTION) {
                        File file = chooser.getSelectedFile();

                        BufferedReader br = new BufferedReader(new FileReader(file));

                        String line;
                        while ((line = br.readLine()) != null) {

                            String[] parts = line.split(" ");
                            int row = Integer.parseInt(parts[0]),
                                    col = Integer.parseInt(parts[1]),
                                    val = Integer.parseInt(parts[2]);

                            int box;
                            row -= 1;
                            col -= 1;

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

                            Square S = b.getSquare(box,index);
                            S.setValue(val);
                            S.setSquareImmutable();
                            b.decreaseSpacesLeft();
                        }


                    }
                } catch (Exception ex) {
                    System.out.println("Exception: " + ex);
                }
                b.updateCandidateList();

            }



        });

        //
        // Composes txt file with 3 values e.g. 2 1 5
        // and saves to user specified location
        //
        // Read as: row 2, column 1, place the value 5
        //
        // Go through each
        //
        //

        save.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                ArrayList<ArrayList<SquarePair>> rowList = b.getRowPairs();
                String saveText = "";

                for (ArrayList<SquarePair> r :  rowList) {

                    for (SquarePair sp : r) {
                        saveText += b.getSquare(sp.getBox(),sp.getIndex()).getBoardRow() + " " + b.getSquare(sp.getBox(),sp.getIndex()).getBoardCol() + " " + b.getSquare(sp.getBox(),sp.getIndex()).getValue() + " ";
                    }

                    saveText += "\n";
                }

                try {
                    BufferedWriter writer = new BufferedWriter(new FileWriter("newFile.txt"));

                    writer.write(saveText);
                    writer.close();
                } catch(Exception ee) {

                }
            }


        });

        exit.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.exit(0);
            }
        });

        fileMenu.add(load);
        fileMenu.add(save);
        fileMenu.add(exit);

        //
        // Action listeners for how to play and use this program
        //

        howToPlay.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JOptionPane.showMessageDialog(null,
                        "Fill in all blank cells making sure that each row,\ncolumn and 3 by 3 box contains the numbers 1 to 9.");
            }
        });

        howToUse.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JOptionPane.showMessageDialog(null,
                        "Start by selecting a board to load into the program via the File > Load option\n" +
                                "Then, in order to fill a square, select a button on the side, then click on a square.\n" +
                                "In order to clear a square, click on the 'X' side button, then on a square you wish to clear.\n" +
                                "To view candidate lists for a square, click on the '?' button, then on a square.\n" +
                                "To use hints, navigate to Hints in the menu bar, then click on the sort of hint you would like.");
            }
        });

        about.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JOptionPane.showMessageDialog(null,
                        "Name, net-id\nPierce Zajac, pzajac2\nChris Janowski, cjanow3");
            }
        });

        infoMenu.add(howToPlay);
        infoMenu.add(howToUse);
        infoMenu.add(about);

        menuBar.add(fileMenu);
        menuBar.add(infoMenu);

        //
        // Action listeners for all hints (toggle valid moves, singles, naked pairs, etc.)
        //
        // Then adding these menu items to panel, and then to menu bar
        //

        toggleValidMoves.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                b.switchToggle();
                toggleValidMoves.setText("Toggle Valid Moves : " + b.toggleIsEnabled());
            }
        });

        //
        // Performs singles algorithm on one square that is clicked
        //

        singles.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                b.singleSolve();
            }
        });

        //
        // Performs hidden singles algorithm on one square that is clicked
        //

        hiddenSingles.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                b.hiddenSingleSolve();
            }
        });

        //
        // Performs naked pairs algorithm on one square that is clicked
        //

        nakedPairs.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                b.nakedPairsSolve();
            }
        });

        //
        // Performs locked candidates algorithm on one square that is clicked
        //

        lockedCandidates.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if(!b.lockedCandidateOne())
                {
                    b.lockedCandidateTwo();
                }
            }
        });

        //
        // Performs all algorithms on all squares or until process ends
        //

        allAlgorithms.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {


                while(b.lockedCandidateOne() || b.lockedCandidateTwo() || b.nakedPairsSolve() || b.singleSolve() || b.hiddenSingleSolve())
                {
                    b.updateCandidateList();
                }


            }
        });

        hintsMenu.add(toggleValidMoves);
        hintsMenu.add(singles);
        hintsMenu.add(hiddenSingles);
        hintsMenu.add(nakedPairs);
        hintsMenu.add(lockedCandidates);
        hintsMenu.add(allAlgorithms);
        menuBar.add(hintsMenu);

        //
        // Grid Panel is used to display sudoku puzzle
        //

        JPanel gridPanel = new JPanel();
        gridPanel.setBackground(Color.BLACK);
        JLabel candidateListLabel = new JLabel("");

        for (int i = 0 ; i < 9 ; ++i) {
            JPanel p = new JPanel(new GridLayout(3,3));

            for (int j = 0 ; j < 9 ; ++j) {

                int x = i;
                int y = j;

                b.getSquare(i,j).getButton().addActionListener(e -> {

                    Square s = b.getSquare(x,y);
                    int editingVal = b.getEditingNum();
                    int squareBox = s.getBoxNumber();
                    int squareRow = s.getBoardRow();
                    int squareCol = s.getBoardCol();

                    if (editingVal == 10) {
                        String candidateString = "Candidate List:";

                        ArrayList<Integer> list = s.getCandidateList();

                        for (int count = 0 ; count < list.size() ; ++count) {
                            candidateString += " ";
                            candidateString += String.valueOf(list.get(count));
                        }


                        candidateListLabel.setText(candidateString);


                    }

                    else {

                        if (b.toggleIsEnabled()) {

                            //
                            // If clearing the square, let it happen
                            //

                            if (editingVal == 0) {
                                b.getSquare(x,y).setValue(b.getEditingNum());

                                b.increaseSpacesLeft();


                            } else {

                                if(s.getCandidateList().contains(editingVal)) {
                                    b.getSquare(x,y).setValue(b.getEditingNum());
                                    b.increaseSpacesLeft();



                                } else {
                                    JOptionPane.showMessageDialog(null,
                                            "Invalid move! " + editingVal + " has already been played in the row/column/box!");
                                }

                            }




                        } else {
                            b.getSquare(x,y).setValue(b.getEditingNum());


                            if (editingVal == 0) {
                                b.increaseSpacesLeft();
                            }
                            else {
                                b.decreaseSpacesLeft();
                            }
                        }




                    }

                    //
                    // Check for win
                    //

                    if (b.getSpacesLeft() == 0) {
                        JOptionPane.showMessageDialog(null,
                                "You win!");
                        System.exit(0);
                    }



                    b.updateCandidateList();



                });
                p.add(b.getSquare(i,j).getButton());
            }

            gridPanel.add(p);

        }


        //
        // Side panel is used to edit squares (i.e. modify values / erase)
        //

        SideButton sideB[] = new SideButton[11];

        for (int i = 0 ; i < 11 ; ++ i) {

            sideB[i] = new SideButton(i);

        }

        JPanel sidePanel = new JPanel(new GridLayout(11,1));

        for (int i = 0 ; i < 11 ; ++i) {

            //
            // Create button with values 0..9 and add action listener
            // 0 being clear button
            //

            int index = i;

            sideB[i].getB().addActionListener(e -> {

                //
                // First set the board's editing number
                // then, make the button that was selected
                // orange and make all other buttons gray
                //


                sideB[index].getB().setOpaque(true);
                sideB[index].getB().setBackground(Color.orange);

                int newEditingNum = sideB[index].getValue();
                b.setEditingNum(newEditingNum);





                for (int j = 0 ; j < 11; ++j) {
                    if (j != index) {
                        sideB[j].getB().setBackground(Color.LIGHT_GRAY);
                        sideB[j].getB().setOpaque(false);
                    }
                }

                System.out.println(b.getEditingNum());

            });

            //
            // Add side buttons to side panel
            //

            sidePanel.add(sideB[i].getB());


        }



        JPanel infoPanel = new JPanel();
        infoPanel.add(candidateListLabel);

        frame.add(gridPanel,BorderLayout.CENTER);
        frame.add(sidePanel,BorderLayout.EAST);
        frame.add(menuBar,BorderLayout.NORTH);
        frame.add(infoPanel,BorderLayout.SOUTH);



    } // end main()
}
