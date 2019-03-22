class BoardView
  include Hyalite::Component

  state :cells, []
  state :selected_cell, nil
  state :mobable_cells, []

  before_mount do
    @props[:game].cells(@props[:turn] == "gote").then do |cells|
      set_state(cells: cells)
    end
    @props[:change_listener] << Proc.new do |cells|
      cells = cells.reverse if @props[:turn] == "gote"
      set_state(cells: cells)
    end
  end

  def movable?(col, row)
    @state[:mobable_cells].include?([col, row])
  end

  def selected?(col, row)
    @state[:selected_cell] == [col, row]
  end

  def handle_cell_click(cell, col, row)
    if cell && cell.turn == @props[:turn]
      @props[:game].dests_from(col, row).then do |dests|
        set_state(selected_cell: [col, row], mobable_cells: dests)
      end
    elsif movable?(col, row)
      (col_from, row_from) = @state[:selected_cell]
      @props[:game].move(col_from, row_from, col, row).then do |cells|
        set_state(cells: cells, selected_cell: nil, mobable_cells: [])
      end
    else
      set_state(selected_cell: nil, mobable_cells: [])
    end
  end

  def render
    turn = @props[:turn]
    div({class: "board"},
      @state[:cells].each_slice(9).each_with_index.map {|row, y|
        rownum = y + 1
        div({class: "board-row"},
          row.each_with_index.map {|cell, x|
            colnum = 9 - x
            CellView.el(
              cell: cell,
              turn: turn,
              selected: selected?(colnum, rownum),
              movable: movable?(colnum, rownum),
              onClick: -> { handle_cell_click(cell, colnum, rownum) }
            )
          }
        )
      }
    )
  end
end
