describe Player do
  let(:game)    { Game.new }
  let(:board)   { game.board }
  let(:player)  { game.human1 }

  describe "attributes" do
    before do
      player.name = "Matz"
    end

    it "has a name" do
      expect(player.name).to eql("Matz")
    end

    it "has a mark" do
      expect(player.mark).to eql("X")
    end
  end

  describe "#throw" do
    it "places mark on board" do
      board.grid = { a: %w[- - -], b: %w[- - -], c: %w[- - -] }
      player.throw("a1", board)
      expect(board.grid).to eql(a: %w[X - -], b: %w[- - -], c: %w[- - -])
    end
  end
end
