creating barebones chess in ruby and testing using rspec

features to add ->
player v comp
50 move draw
3 fold repitition
touch to move
insufficient material

-> insufficient material 
Lone king vs all the pieces (timeout vs insufficient material) very rare so less priority

-> improvements
better design (ood)
making the structure of enpassant branch and castle branch similar # nt that imp rn
make @last_move store castling/passant moves too

ideas : human and comp both inherit from a player to implement player v comp

good test fen: ('r3kbnr/ppppp1pp/5p2/8/4P3/8/PPPP1PPP/RNBQK2R')