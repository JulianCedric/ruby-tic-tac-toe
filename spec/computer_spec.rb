require "spec_helper"

describe Computer do
  let(:game)     { Game.new }
  let(:computer) { game.computer }
  let(:board)    { game.board }

  describe "attributes" do
    it "has a name" do
      expect(computer.name).to eql("Computer")
    end

    it "has a mark" do
      expect(computer.mark).to eql("O")
    end

    it "knows about human mark" do
      expect(computer.human_mark).to eql("X")
    end

    it "knows about board" do
      raise unless computer.board.grid
    end
  end

  describe "#throw" do
    before do
      expect(board).to receive(:print_board).twice
      expect(STDOUT).to receive(:puts).with("Computer turn...")
      expect(computer).to receive(:sleep)
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
        board.grid = { a: %w[O X O],
                       b: %w[- - X],
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

    context "with two computer marks in a diagonal" do
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
