module gofl_simul;
import cst_rl;

struct Simulation
{
    bool run;
    int cells_live;

    Grid grid;
}

const ichar[<2>][8] NEIGHBORS_OFFSETS @local =
{
    {-1, 0 },
    { 1, 0 },
    { 0,-1 },
    { 0, 1 },
    {-1,-1 },
    {-1, 1 },
    { 1,-1 },
    { 1, 1 }
};


fn int Simulation.getValue(Simulation* self, Table grid) @inline =>
    self.isWithinBounds(grid) ? self.grid.getValue(grid):0;

/**
 * @require grid.x >= 0, grid.y >= 0
 **/
macro bool Simulation.isWithinBounds(Simulation* self, Table grid) @local =>
    grid.x < self.grid.rows && grid.y < self.grid.columns;

macro int Simulation.countLiveNeighbors(Simulation* self, Table *grid) @local {
    var live_neighbors = 0;

    foreach (offset: NEIGHBORS_OFFSETS) live_neighbors += self.getValue({
        (grid.x + offset.x + self.grid.getRows()) % self.grid.getRows(),
        (grid.y + offset.y + self.grid.getColumns()) % self.grid.getColumns()
    });

    return live_neighbors;
}

macro void Simulation.draw(Simulation* self) => self.grid.draw();
macro void Simulation.clearGrid(Simulation* self) => self.grid.clear();

fn void Simulation.toggleCell(Simulation* self, Table grid, bool action, char v) {
    if (action && !self.@isRunning() && self.isWithinBounds(grid)) self.grid.toggleCell(&grid, v);
}

macro int Simulation.getLivingCells(Simulation* self) => self.cells_live;

macro void Simulation.stop(Simulation* self) => self.run = false;
macro void Simulation.start(Simulation* self) => self.run = true;

macro bool Simulation.@isRunning(Simulation* &self) => self.run;
macro void Simulation.createRandomState(Simulation* self) => self.grid.fillRandom();

fn void Simulation.update(Simulation* self) {
    if (!self.@isRunning()) return;

    Grid temp_grid = self.grid;

    foreach (int idxr, &row: self.grid.cells) foreach (int idxc, &_n: *row) {
        Table posp = { idxr, idxc };
        Table* pos = &posp;

        int live_neighbors = self.countLiveNeighbors(pos);
        int cell_value = self.getValue(*pos);

        if (cell_value) {
            if (live_neighbors > 3 || live_neighbors < 2) {
                temp_grid.setValue(pos, 0);
                continue;
            }

            self.grid.setLivingCells();
            temp_grid.setValue(pos, 1);

            continue;
        }

        if (live_neighbors == 3) {
            self.grid.setLivingCells();
            temp_grid.setValue(pos, 1);

            continue;
        }

        temp_grid.setValue(pos, 0);
    }

    self.cells_live = self.grid.l_cells;
    self.grid = temp_grid;
}
