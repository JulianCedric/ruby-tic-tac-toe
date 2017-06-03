describe Computer do
  let(:game)     { Game.new }
  let(:computer) { game.computer }
  let(:board)    { game.board }
  let(:printer)  { game.printer }
  let(:ai)       { computer.ai }

  describe "attributes" do
    it "has a name" do
      expect(computer.name).to eql("Computer")
    end

    it "has a mark" do
      expect(computer.mark).to eql("O")
    end

    it "knows about human" do
      expect(computer.human).to be_a(Player)
    end

    it "knows about board" do
      expect(board).to be_a(Board)
    end

    it "has an AI" do
      expect(ai).to be_an(AI)
    end
  end

  describe "#throw" do
    before do
      allow(printer).to receive(:print_board)
      allow(STDOUT).to receive(:puts).with("Computer turn...")
      allow(computer).to receive(:sleep)
    end

    context "with two computer marks in a row" do
      it "adds mark in line and wins" do
        board.grid = { a: %w[O - O],
                       b: %w[X - X],
                       c: %w[X O X] }
        computer.throw
        expect(board.grid[:a][1]).to eql("O")
      end
    end

    context "with two computer marks in a column" do
      it "adds mark in line and wins" do
        board.grid = { a: %w[O X X],
                       b: %w[- - O],
                       c: %w[O X X] }
        computer.throw
        expect(board.grid[:b][0]).to eql("O")
      end
    end

    context "with two computer marks in a diagonal" do
      it "adds mark in line and wins" do
        board.grid = { a: %w[O X O],
                       b: %w[X - X],
                       c: %w[- X O] }
        computer.throw
        expect(board.grid[:b][1]).to eql("O")
      end
    end

    context "with two human marks in a row" do
      it "adds mark in between" do
        board.grid = { a: %w[- - O],
                       b: %w[O - X],
                       c: %w[X - X] }
        computer.throw
        expect(board.grid[:c][1]).to eql("O")
      end
    end

    context "with two human marks in a column" do
      it "adds mark in between" do
        board.grid = { a: %w[O X O],
                       b: %w[- - O],
                       c: %w[- X X] }
        computer.throw
        expect(board.grid[:b][1]).to eql("O")
      end
    end

    context "with two human marks in a diagonal" do
      it "adds mark in between" do
        board.grid = { a: %w[X O O],
                       b: %w[- - X],
                       c: %w[- - X] }
        computer.throw
        expect(board.grid[:b][1]).to eql("O")
      end
    end
  end
end
