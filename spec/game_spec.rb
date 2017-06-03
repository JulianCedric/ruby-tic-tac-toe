describe Game do
  let(:game)     { Game.new }
  let(:human1)   { game.human1 }
  let(:human2)   { game.human2 }
  let(:computer) { game.computer }
  let(:board)    { game.board }
  let(:printer)  { game.printer }
  let(:judge)    { game.judge }

  describe "attributes" do
    it "has a board" do
      expect(board).to be_a(Board)
    end

    it "knows about printer" do
      expect(printer).to be_a(Printer)
    end

    it "has a judge" do
      expect(judge).to be_a(Judge)
    end

    it "has one player by default" do
      expect(game.players).to be(1)
    end

    it "human1 is a Player" do
      expect(game.human1).to be_a(Player)
    end

    it "human2 is a Player" do
      expect(game.human2).to be_a(Player)
    end

    it "has a computer player" do
      expect(computer).to be_a(Computer)
    end
  end

  before do
    allow(printer).to receive(:print_board)
  end

  describe "#setup" do
    context "when there is one player" do
      it "starts game" do
        allow(game).to receive(:puts).with("Choose players, 1 or 2?")
        allow(STDIN).to receive(:gets).and_return("1")
        allow(game).to receive(:start_game)
        game.setup
        expect(game).to have_received(:puts).with("Choose players, 1 or 2?")
      end
    end

    context "when there are two players" do
      before do
        game.players = 2
        allow(game).to receive(:choose_players)
        allow(STDIN).to receive(:gets).and_return("2")
        allow(game).to receive(:puts).with("Player 1 name:")
        allow(STDIN).to receive(:gets).and_return("Sandi")
        allow(game).to receive(:puts).with("Player 2 name:")
        allow(STDIN).to receive(:gets).and_return("Matz")
        allow(game).to receive(:start_game)
        game.setup
      end

      it "asks player one name" do
        expect(game).to have_received(:puts).with("Player 1 name:")
      end

      it "asks player two name" do
        expect(game).to have_received(:puts).with("Player 2 name:")
      end
    end
  end

  describe "#start_game" do
    before do
      allow(game).to receive(:loop).and_yield
    end

    context "when there is one player" do
      it "asks player for position" do
        allow(game).to receive(:puts).with("Introduce a position:")
        allow(STDIN).to receive(:gets).and_return("c1")
        allow(computer).to receive(:throw)
        game.start_game
        expect(game).to have_received(:puts).with("Introduce a position:")
      end
    end

    context "when there are two players" do
      before do
        game.players = 2
        allow(game).to receive(:puts)
          .with("#{human1.name}, introduce a position:")
        allow(STDIN).to receive(:gets).and_return("a1")
        allow(human1).to receive(:throw)
        allow(game).to receive(:puts)
          .with("#{human2.name}, introduce a position:")
        allow(STDIN).to receive(:gets).and_return("c3")
        allow(human2).to receive(:throw)
        game.start_game
      end

      it "asks player one for position using player's name" do
        expect(game).to have_received(:puts)
          .with("#{human1.name}, introduce a position:")
      end

      it "asks player two for position using player's name" do
        expect(game).to have_received(:puts)
          .with("#{human2.name}, introduce a position:")
      end
    end
  end

  describe "#retry_turn" do
    before do
      player = human1
      allow(game).to receive(:ask_for_position)
      allow(player).to receive(:throw)
      game.retry_turn(player)
    end

    it "doesn't print board" do
      expect(printer).not_to have_received(:print_board)
    end
  end

  describe "#try_again" do
    before do
      allow(game).to receive(:loop).and_yield
    end

    it "restarts game when input is 'y'" do
      allow(STDIN).to receive(:gets).and_return("y")
      allow(game).to receive(:restart_game)
      game.try_again
      expect(game).to have_received(:restart_game)
    end

    it "exits game when input is 'n'" do
      allow(STDIN).to receive(:gets).and_return("n")
      allow(game).to receive(:exit_game)
      game.try_again
    end

    it "asks to type 'y' or 'n' otherwise" do
      allow(STDIN).to receive(:gets).and_return("daskn")
      allow(game).to receive(:type_yes_or_no)
      game.try_again
    end
  end
end
