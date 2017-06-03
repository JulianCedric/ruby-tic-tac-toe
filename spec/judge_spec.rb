describe Judge do
  let(:game)     { Game.new }
  let(:board)    { game.board }
  let(:printer)  { game.printer }
  let(:judge)    { game.judge }
  let(:human)    { game.human1 }
  let(:computer) { game.computer }

  describe "attributes" do
    it "knows about game" do
      expect(judge.game).to be_a(Game)
    end

    it "knows about board" do
      expect(judge.board).to be_a(Board)
    end

    it "knows about printer" do
      expect(judge.printer).to be_a(Printer)
    end
  end

  describe "#check_for_winner" do
    context "when there's a winning line in a row" do
      before do
        allow(printer).to receive(:print_board)
        allow(game).to receive(:try_again)
      end

      it "finds human as a winner" do
        board.grid = { a: %w[X X X], b: %w[- - -], c: %w[- - -] }
        allow(judge).to receive(:puts).with("YOU WIN! Try again? (Y/N)")
        judge.check_for_winner(human)
        expect(judge).to have_received(:puts).with("YOU WIN! Try again? (Y/N)")
      end

      it "finds computer as a winner" do
        board.grid = { a: %w[O O O], b: %w[- - -], c: %w[- - -] }
        allow(judge).to receive(:puts).with("Computer wins! Try again? (Y/N)")
        judge.check_for_winner(computer)
        expect(judge).to have_received(:puts)
          .with("Computer wins! Try again? (Y/N)")
      end
    end

    context "when there's a winning line in a column" do
      before do
        allow(printer).to receive(:print_board)
        allow(game).to receive(:try_again)
      end

      it "finds human as a winner" do
        board.grid = { a: %w[X - -], b: %w[X - -], c: %w[X - -] }
        allow(judge).to receive(:puts).with("YOU WIN! Try again? (Y/N)")
        judge.check_for_winner(human)
        expect(judge).to have_received(:puts).with("YOU WIN! Try again? (Y/N)")
      end

      it "finds computer as a winner" do
        board.grid = { a: %w[O - -], b: %w[O - -], c: %w[O - -] }
        allow(judge).to receive(:puts).with("Computer wins! Try again? (Y/N)")
        judge.check_for_winner(computer)
        expect(judge).to have_received(:puts)
          .with("Computer wins! Try again? (Y/N)")
      end
    end

    context "when there's a winning line in a diagonal" do
      before do
        allow(printer).to receive(:print_board)
        allow(game).to receive(:try_again)
      end

      it "finds human as a winner" do
        board.grid = { a: %w[X - -], b: %w[- X -], c: %w[- - X] }
        allow(judge).to receive(:puts).with("YOU WIN! Try again? (Y/N)")
        judge.check_for_winner(human)
        expect(judge).to have_received(:puts).with("YOU WIN! Try again? (Y/N)")
      end

      it "finds computer as a winner" do
        board.grid = { a: %w[O - -], b: %w[- O -], c: %w[- - O] }
        allow(judge).to receive(:puts).with("Computer wins! Try again? (Y/N)")
        judge.check_for_winner(computer)
        expect(judge).to have_received(:puts)
          .with("Computer wins! Try again? (Y/N)")
      end
    end

    context "when there's no winner" do
      before do
        allow(printer).to receive(:print_board)
        allow(game).to receive(:try_again)
      end

      it "says so" do
        board.grid = { a: %w[X O X], b: %w[X O O], c: %w[O X X] }
        allow(judge).to receive(:puts)
          .with("There's no winner. Try again? (Y/N)")
        judge.check_for_winner(human)
        expect(judge).to have_received(:puts)
          .with("There's no winner. Try again? (Y/N)")
      end
    end
  end
end
