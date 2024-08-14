module gameoflifec3;
import raylib;

const int[<32>][32] D_GRID = { [0..32] = {[0..32] = 0} };

struct Grid
{
    int rows;
    int columns;

    int[<32>][32] cells;
    int l_cells;
}

macro void Grid.setValue(Grid* self, Table grid, uint value) => self.cells[grid.x][grid.y] = value;
macro int Grid.getValue(Grid* self, Table grid) => self.cells[grid.x][grid.y];

macro int Grid.getRows(Grid* self) => self.rows;
macro int Grid.getColumns(Grid* self) => self.columns;

fn void Grid.setLivingCells(Grid* self) => self.l_cells++;

fn void Grid.fillRandom(Grid* self) {
    foreach (&row: self.cells) {
        foreach (&column: row)
        {
            int random_value = raylib::get_random_value(0, 4);
            *column = (random_value == 4)? 1:0;
        }
    }
}

fn Grid grid(uint width, uint height) =>
{
    (height - 80) / GRD_CELL_SIZE,
    width / GRD_CELL_SIZE, D_GRID, 0
};

fn void Grid.clear(Grid *self) {
    self.cells = D_GRID;
}

fn void Grid.toggleCell(Grid* self, Table grid) {
    self.setValue(grid, !self.cells[grid.x][grid.y]? 1:0);
}

fn void Grid.hoverCell(Grid* self, Table grid) {
    self.setValue(grid, 2);
}

fn void Grid.draw(Grid* self) @private {
    char center_cell_size = GRD_CELL_SIZE-2;

    foreach (char idxr, row: self.cells) {
        foreach (char idxc, column: row)
        {
            Color color = column? GRD_CELL_DEAD : GRD_CELL_LIFE;
            bool state_column = column? true:false;

            int grid_row = idxc * GRD_CELL_SIZE+6;
            int grid_column = idxr * GRD_CELL_SIZE+PDG_TOP-3;

            raylib::draw_rectangle(
                grid_row, grid_column,
                center_cell_size, center_cell_size, color
            );

            if (column != 2 && state_column) {
                raylib::draw_rectangle_lines(
                    grid_row, grid_column,
                    center_cell_size, center_cell_size, {10, 10, 10, 255}
                );

                continue;
            }

            self.setValue({idxr, idxc}, 0);
        }
    }
}
