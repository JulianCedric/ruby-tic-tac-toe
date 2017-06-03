describe Board do
  let(:game)    { Game.new }
  let(:board)   { game.board }
  let(:printer) { board.printer }
  let(:player)  { game.human1 }

  describe "attributes" do
    it "has a grid" do
      expect(board.grid).to eql(a: %w[- - -], b: %w[- - -], c: %w[- - -])
    end

    it "knows about game" do
      expect(board.game).to be_a(Game)
    end

    it "has a printer" do
      expect(board.printer).to be_a(Printer)
    end
  end

  describe "#place_mark" do
    before do
      board.grid[:a][0] = "X"
    end

    let(:coordinates) { "a1" }

    context "when the position is not available" do
      before do
        allow(printer).to receive(:print_board)
        allow(game).to receive(:retry_turn)
      end

      it "says the position is already taken" do
        allow(board).to receive(:puts)
          .with("The position '#{coordinates}' is already taken.\n\n")
        board.place_mark(player.mark, coordinates, player)
        expect(board).to have_received(:puts)
          .with("The position '#{coordinates}' is already taken.\n\n")
      end
    end

    context "when the position is available" do
      it "places mark" do
        board.place_mark(player.mark, "a3", player)
        expect(board.grid[:a][2]).to eql("X")
      end
    end
  end

  describe "#slot_available?" do
    before do
      board.grid[:a][0] = "X"
    end

    context "when the slot is available" do
      it "returns 'true'" do
        expect(board.slot_available?("a3")).to be(true)
      end
    end

    context "when the slot is not available" do
      it "returns 'false'" do
        expect(board.slot_available?("a1")).to be(false)
      end
    end
  end

  describe "#reset_grid" do
    before do
      board.grid[:a][0] = "X"
    end

    it "resets grid" do
      board.reset_grid
      expect(board.grid).to eql(a: %w[- - -], b: %w[- - -], c: %w[- - -])
    end
  end
end
