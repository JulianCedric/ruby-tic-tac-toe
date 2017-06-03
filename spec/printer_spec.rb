describe Printer do
  let(:game)    { Game.new }
  let(:board)   { game.board }
  let(:printer) { board.printer }

  describe "attributes" do
    it "knows about grid" do
      expect(printer.grid).to be_a(Hash)
    end
  end

  describe "#print_board" do
    it "prints board" do
      allow(printer).to receive(:system).with("clear")
      allow(printer).to receive(:system).with("cls")
      allow(printer).to receive(:puts).exactly(17).times
      printer.print_board
      expect(printer).to have_received(:puts).exactly(17).times
    end
  end
end
